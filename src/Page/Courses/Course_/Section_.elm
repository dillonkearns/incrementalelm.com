module Page.Courses.Course_.Section_ exposing (Data, Model, Msg, page)

import Css
import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import DataSource.Http
import Duration exposing (Duration)
import Graphql.OptionalArgument as OptionalArgument
import Graphql.SelectionSet as SelectionSet
import Head
import Head.Seo as Seo
import Html.Styled as Html
import Html.Styled.Attributes as Attr exposing (css)
import Html.Styled.Keyed
import Link
import MarkdownCodec
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Request
import Route
import SanityApi.InputObject as InputObject
import SanityApi.Object.Chapter
import SanityApi.Object.MuxVideo
import SanityApi.Object.MuxVideoAsset
import SanityApi.Query
import Secrets
import Shared
import Tailwind.Utilities as Tw
import TailwindMarkdownRenderer2
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { course : String, section : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    pages


muxIdToDuration : String -> DataSource Duration
muxIdToDuration muxId =
    DataSource.Http.request
        (Secrets.succeed
            (\muxAuthToken ->
                { url = "https://api.mux.com/video/v1/assets/" ++ muxId
                , method = "GET"
                , headers =
                    [ ( "Authorization", "Basic " ++ muxAuthToken )
                    ]
                , body = DataSource.Http.emptyBody
                }
            )
            |> Secrets.with "MUX_AUTH_TOKEN"
        )
        (Decode.at [ "data", "duration" ] Decode.float
            |> Decode.map Basics.floor
            |> Decode.map Duration.fromSeconds
        )


currentChapterMuxId : RouteParams -> DataSource String
currentChapterMuxId routeParams =
    let
        _ =
            Debug.log "routeParams" routeParams.section
    in
    SanityApi.Query.allChapter
        (\optionals ->
            { optionals
                | where_ =
                    InputObject.buildChapterFilter
                        (\chapterOptionals ->
                            { chapterOptionals
                                | slug =
                                    InputObject.buildSlugFilter
                                        (\slugFilter ->
                                            { slugFilter
                                                | current =
                                                    InputObject.buildStringFilter
                                                        (\stringFilter ->
                                                            { stringFilter
                                                                | eq = OptionalArgument.Present routeParams.section
                                                            }
                                                        )
                                                        |> OptionalArgument.Present
                                            }
                                        )
                                        |> OptionalArgument.Present
                            }
                        )
                        |> OptionalArgument.Present
            }
        )
        (SanityApi.Object.Chapter.video
            (SanityApi.Object.MuxVideo.asset SanityApi.Object.MuxVideoAsset.assetId
                |> SelectionSet.nonNullOrFail
            )
            |> SelectionSet.nonNullOrFail
            |> SelectionSet.nonNullOrFail
        )
        |> SelectionSet.map List.head
        |> SelectionSet.nonNullOrFail
        |> Request.staticGraphqlRequest


courseChapters : RouteParams -> DataSource (List ( Metadata, Duration ))
courseChapters current =
    pages
        |> DataSource.map
            (List.filterMap
                (\chapter ->
                    if chapter.course == current.course then
                        DataSource.map2 Tuple.pair
                            (findFilePath chapter
                                |> DataSource.andThen
                                    (\filePath ->
                                        DataSource.File.onlyFrontmatter (metadataDecoder chapter) filePath
                                    )
                            )
                            (chapter
                                |> currentChapterMuxId
                                |> DataSource.andThen muxIdToDuration
                            )
                            |> Just

                    else
                        Nothing
                )
            )
        |> DataSource.resolve


pages : DataSource (List RouteParams)
pages =
    Glob.succeed
        (\course order section ->
            { course = course
            , order = order
            , section = section
            }
        )
        |> Glob.match (Glob.literal "content/courses/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal "/")
        |> Glob.capture Glob.int
        |> Glob.match (Glob.literal "-")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource
        |> DataSource.map
            (\sections ->
                sections
                    |> List.sortBy .order
                    |> List.map
                        (\item ->
                            { course = item.course
                            , section = item.section
                            }
                        )
            )


type alias Metadata =
    { routeParams : RouteParams
    , mediaId : String
    , title : String
    }


data : RouteParams -> DataSource Data
data routeParams =
    findFilePath routeParams
        |> DataSource.andThen
            (\filePath ->
                DataSource.map3 Data
                    (DataSource.File.onlyFrontmatter (metadataDecoder routeParams) filePath)
                    (MarkdownCodec.withoutFrontmatter TailwindMarkdownRenderer2.renderer filePath
                        |> DataSource.resolve
                    )
                    (courseChapters routeParams)
            )


metadataDecoder : RouteParams -> Decoder Metadata
metadataDecoder routeParams =
    Decode.map2 (Metadata routeParams)
        (Decode.field "mediaId" Decode.string)
        (Decode.field "title" Decode.string)


findFilePath : RouteParams -> DataSource String
findFilePath routeParams =
    Glob.succeed identity
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/courses/")
        |> Glob.match (Glob.literal routeParams.course)
        |> Glob.match (Glob.literal "/")
        |> Glob.match Glob.int
        |> Glob.match (Glob.literal "-")
        |> Glob.match (Glob.literal routeParams.section)
        |> Glob.match (Glob.literal ".md")
        |> Glob.expectUniqueMatch


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    { metadata : Metadata
    , body : List (Html.Html Never)
    , chapters : List ( Metadata, Duration )
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = ""
    , body =
        View.Tailwind
            [ Html.Styled.Keyed.node "div"
                [ css
                    [ Tw.flex
                    , Tw.justify_around
                    , Tw.flex_grow
                    ]
                ]
                [ ( "my-player-" ++ static.routeParams.section
                  , Html.Styled.Keyed.node "hls-video"
                        [ Attr.id <| "my-player-" ++ static.routeParams.section
                        , Attr.src <| "/.netlify/functions/sign_playback_id?playbackId=" ++ static.data.metadata.mediaId
                        , Attr.controls True
                        , Attr.preload "auto"
                        , Attr.style "border" "solid 2px blue"
                        , Attr.style "width" "800px"
                        , Attr.style "width" "800px"
                        , Attr.style "height" "450px"
                        ]
                        []
                  )
                ]
            , chaptersView static.data.metadata static.data.chapters
            , Html.div [] static.data.body
            ]
    }


chaptersView : Metadata -> List ( Metadata, Duration ) -> Html.Html msg
chaptersView current chapters =
    Html.ol []
        (chapters |> List.indexedMap (chapterView current))


chapterView : Metadata -> Int -> ( Metadata, Duration ) -> Html.Html msg
chapterView currentPage index ( chapter, duration ) =
    Html.li
        [ css
            [ if currentPage.routeParams == chapter.routeParams then
                Tw.bg_accent1

              else
                Tw.bg_background
            , Css.hover
                [ Tw.bg_accent1
                ]
            ]
        ]
        [ Route.Courses__Course___Section_ chapter.routeParams
            |> Link.htmlLink2
                [ css
                    [ Tw.w_full
                    ]
                ]
                [ Html.text <| String.fromInt (index + 1) ++ ". "
                , Html.text (chapter.title ++ " ")
                , Duration.view duration
                ]
        ]

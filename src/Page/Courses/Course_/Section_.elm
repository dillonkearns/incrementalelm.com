module Page.Courses.Course_.Section_ exposing (Data, Model, Msg, page)

import Cloudinary
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
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr exposing (css)
import Html.Styled.Keyed
import Link
import List.Extra
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
import Tailwind.Breakpoints as Bp
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


currentChapterMuxId : RouteParams -> DataSource { assetId : String, playbackId : String }
currentChapterMuxId routeParams =
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
            (SanityApi.Object.MuxVideo.asset
                (SelectionSet.map2
                    (\assetId playbackId ->
                        { assetId = assetId
                        , playbackId = playbackId
                        }
                    )
                    (SanityApi.Object.MuxVideoAsset.assetId
                        |> SelectionSet.nonNullOrFail
                    )
                    (SanityApi.Object.MuxVideoAsset.playbackId
                        |> SelectionSet.nonNullOrFail
                    )
                )
                |> SelectionSet.nonNullOrFail
            )
            |> SelectionSet.nonNullOrFail
        )
        |> SelectionSet.map List.head
        |> SelectionSet.nonNullOrFail
        |> Request.staticGraphqlRequest


courseChapters : RouteParams -> DataSource (List Metadata)
courseChapters current =
    pages
        |> DataSource.map
            (List.filterMap
                (\chapter ->
                    if chapter.course == current.course then
                        (findFilePath chapter
                            |> DataSource.andThen
                                (\filePath -> metadata filePath chapter)
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
    , title : String
    , description : String
    , duration : Duration
    , playbackId : String
    , free : Bool
    }


data : RouteParams -> DataSource Data
data routeParams =
    findFilePath routeParams
        |> DataSource.andThen
            (\filePath ->
                DataSource.map3 Data
                    --(DataSource.File.onlyFrontmatter (metadataDecoder routeParams) filePath)
                    (metadata filePath routeParams)
                    (MarkdownCodec.withoutFrontmatter TailwindMarkdownRenderer2.renderer filePath
                        |> DataSource.resolve
                    )
                    (courseChapters routeParams)
            )



--metadataDecoder : RouteParams -> Decoder Metadata
--metadataDecoder routeParams =
--    Decode.map2 (Metadata routeParams)
--        (Decode.field "playbackId" Decode.string)
--        (Decode.field "title" Decode.string)


metadata : String -> RouteParams -> DataSource Metadata
metadata filePath routeParams =
    DataSource.map2
        (\frontmatter other ->
            { routeParams = routeParams
            , title = frontmatter.title
            , description = frontmatter.description
            , free = frontmatter.free
            , duration = other.duration
            , playbackId = other.playbackId
            }
        )
        (filePath
            |> DataSource.File.onlyFrontmatter
                (Decode.map3
                    (\title description free ->
                        { title = title
                        , description = description
                        , free = free
                        }
                    )
                    (Decode.field "title" Decode.string)
                    (Decode.field "description" Decode.string)
                    (Decode.optionalField "free" Decode.bool |> Decode.map (Maybe.withDefault False))
                )
        )
        (routeParams
            |> currentChapterMuxId
            |> DataSource.andThen
                (\info ->
                    DataSource.succeed
                        (\duration ->
                            { playbackId = info.playbackId
                            , duration = duration
                            }
                        )
                        |> DataSource.andMap (muxIdToDuration info.assetId)
                )
        )


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
            { url = Cloudinary.url "v1636406821/elm-ts-interop-course.svg" Nothing 600
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = static.data.metadata.description
        , locale = Nothing
        , title = "elm-ts-interop course - " ++ static.data.metadata.title
        }
        |> Seo.website


type alias Data =
    { metadata : Metadata
    , body : List (Html.Html Never)
    , chapters : List Metadata
    }


goProView : Html msg
goProView =
    Html.div []
        [ Html.text "Go pro to see this video"
        ]


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    let
        loggedInSubscriber =
            sharedModel.user |> Maybe.map .isPro |> Maybe.withDefault False
    in
    { title = ""
    , body =
        View.Tailwind
            [ titleView static.data.metadata.title
            , if static.data.metadata.free || loggedInSubscriber then
                Html.Styled.Keyed.node "div"
                    [ css
                        [ Tw.flex
                        , Tw.justify_around
                        , Tw.flex_grow
                        ]
                    ]
                    [ ( "my-player-" ++ static.routeParams.section
                      , Html.Styled.Keyed.node "hls-video"
                            [ Attr.id <| "my-player-" ++ static.routeParams.section
                            , Attr.src <| "/.netlify/functions/sign_playback_id?playbackId=" ++ static.data.metadata.playbackId
                            , Attr.controls True
                            , Attr.preload "auto"
                            , css
                                [ Bp.lg [ size 800 ]
                                , Bp.md [ size 600 ]
                                , Bp.sm [ size 500 ]
                                , size 300
                                , Tw.mb_6
                                ]
                            ]
                            []
                      )
                    ]

              else
                goProView
            , nextPreviousView static.data.metadata static.data.chapters
            , chaptersView static.data.metadata static.data.chapters
            , Html.div
                [ css
                    [ Tw.mt_12
                    ]
                ]
                (subTitleView "Chapter Notes"
                    :: static.data.body
                )
            ]
    }


titleView : String -> Html.Html msg
titleView titleText =
    Html.h1
        [ css
            [ Tw.text_4xl
            , Tw.font_bold
            , Tw.tracking_tight
            , Tw.mt_2
            , Tw.mb_8
            , [ Css.qt "Raleway" ] |> Css.fontFamilies
            , Tw.text_foregroundStrong
            ]
        ]
        [ Html.text titleText ]


subTitleView : String -> Html.Html msg
subTitleView titleText =
    Html.h2
        [ css
            [ Tw.text_3xl
            , Tw.font_bold
            , Tw.tracking_tight
            , Tw.mt_2
            , Tw.mb_8
            , [ Css.qt "Raleway" ] |> Css.fontFamilies
            , Tw.text_foregroundStrong
            ]
        ]
        [ Html.text titleText ]


size : Float -> Css.Style
size width =
    Css.batch
        [ Css.width (Css.px width)
        , Css.height (Css.px (width * 0.5625))
        ]


nextPreviousView : Metadata -> List Metadata -> Html.Html msg
nextPreviousView current chapters =
    let
        currentIndex : Int
        currentIndex =
            chapters
                |> List.Extra.findIndex ((==) current)
                |> Maybe.withDefault 0

        previous : Maybe Metadata
        previous =
            chapters |> List.Extra.getAt (currentIndex - 1)

        next : Maybe Metadata
        next =
            chapters |> List.Extra.getAt (currentIndex + 1)
    in
    Html.div
        [ css
            [ Tw.mb_6
            , Tw.flex
            , Tw.justify_between
            , Tw.flex_col
            , Bp.md
                [ Tw.flex_row
                ]
            , Tw.w_full
            , Tw.gap_2
            ]
        ]
        [ previous
            |> nextPreviousButton Previous
        , next
            |> nextPreviousButton Next
        ]


type NextOrPrevious
    = Next
    | Previous


nextPreviousButton : NextOrPrevious -> Maybe Metadata -> Html.Html msg
nextPreviousButton kind maybeNextOrPrevious =
    maybeNextOrPrevious
        |> Maybe.map
            (\nextOrPrevious ->
                Route.Courses__Course___Section_ nextOrPrevious.routeParams
                    |> Link.htmlLink2
                        [ css
                            [ Css.hover
                                [ Tw.bg_foregroundStrong
                                , Tw.underline
                                ]
                            , Tw.px_4
                            , Tw.py_2
                            , Tw.bg_foreground
                            , Tw.text_background
                            , Tw.rounded_lg
                            , Tw.text_center
                            ]
                        ]
                        [ case kind of
                            Previous ->
                                Html.text <| "<- " ++ nextOrPrevious.title

                            Next ->
                                Html.text <| nextOrPrevious.title ++ " ->"
                        ]
            )
        |> Maybe.withDefault (Html.span [] [])


chaptersView : Metadata -> List Metadata -> Html.Html msg
chaptersView current chapters =
    Html.ol []
        (chapters |> List.indexedMap (chapterView current))


chapterView : Metadata -> Int -> Metadata -> Html.Html msg
chapterView currentPage index chapter =
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
                    [ Tw.flex
                    , Tw.justify_between
                    , Tw.p_2
                    ]
                ]
                [ Html.div
                    [ css
                        [ Tw.gap_3
                        , Tw.flex
                        ]
                    ]
                    [ Html.span
                        [ css
                            []
                        ]
                        [ Html.text <| String.fromInt (index + 1) ++ ". " ]
                    , Html.span
                        [ css
                            [ Tw.text_foregroundStrong
                            , Tw.font_bold
                            ]
                        ]
                        [ Html.text (chapter.title ++ " ") ]
                    ]
                , Duration.view
                    [ css
                        [ Tw.py_1
                        , Tw.px_2
                        , Tw.bg_foregroundStrong
                        , Tw.rounded_xl
                        , Tw.text_background
                        , Tw.text_sm
                        ]
                    ]
                    chapter.duration
                ]
        ]

module Page.Courses.Course_.Section_ exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Head
import Head.Seo as Seo
import Html.Styled as Html
import Html.Styled.Attributes as Attr exposing (css)
import Html.Styled.Keyed
import MarkdownCodec
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
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
    { mediaId : String
    }


data : RouteParams -> DataSource Data
data routeParams =
    findFilePath routeParams
        |> DataSource.andThen
            (\filePath ->
                DataSource.map2 Data
                    (DataSource.File.onlyFrontmatter metadataDecoder filePath)
                    (MarkdownCodec.withoutFrontmatter TailwindMarkdownRenderer2.renderer filePath
                        |> DataSource.resolve
                    )
            )


metadataDecoder : Decoder Metadata
metadataDecoder =
    Decode.map Metadata
        (Decode.field "mediaId" Decode.string)


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
            [ Html.div
                [ css
                    [ Tw.flex
                    , Tw.justify_around
                    , Tw.flex_grow
                    ]
                ]
                [ Html.Styled.Keyed.node "hls-video"
                    [ Attr.id "my-player"
                    , Attr.src <| "/.netlify/functions/sign_playback_id?playbackId=" ++ static.data.metadata.mediaId
                    , Attr.controls True
                    , Attr.preload "auto"
                    , Attr.style "border" "solid 2px blue"
                    , Attr.style "width" "800px"
                    , Attr.style "width" "800px"
                    , Attr.style "height" "450px"
                    ]
                    []
                ]
            , Html.div [] static.data.body
            ]
    }

module Route.Courses.Course_.Section_ exposing (ActionData, Data, Metadata, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import BackendTask.Env
import BackendTask.File
import BackendTask.Glob as Glob
import BackendTask.Http
import Cloudinary
import Dict exposing (Dict)
import Duration exposing (Duration)
import FatalError exposing (FatalError)
import Graphql.OptionalArgument as OptionalArgument
import Graphql.SelectionSet as SelectionSet
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Keyed
import Json.Decode as Decode exposing (Decoder)
import Link
import List.Extra
import MarkdownCodec
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Request
import Route
import RouteBuilder exposing (App, StatelessRoute)
import SanityApi.InputObject as InputObject
import SanityApi.Object.Chapter
import SanityApi.Object.MuxVideo
import SanityApi.Object.MuxVideoAsset
import SanityApi.Query
import Shared
import Shiki
import Tailwind as Tw exposing (batch, classes)
import Tailwind.Breakpoints exposing (lg, md, sm)
import Tailwind.Theme exposing (accent1, background, s1, s12, s2, s4, s6, s8)
import TailwindMarkdownViewRenderer
import UrlPath exposing (UrlPath)
import View exposing (View, freeze)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { course : String, section : String }


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.preRender
        { head = head
        , pages = pages
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


muxIdToDuration : String -> BackendTask FatalError Duration
muxIdToDuration muxId =
    BackendTask.Env.expect "MUX_AUTH_TOKEN"
        |> BackendTask.allowFatal
        |> BackendTask.andThen
            (\authToken ->
                BackendTask.Http.getWithOptions
                    { url = "https://api.mux.com/video/v1/assets/" ++ muxId
                    , expect =
                        BackendTask.Http.expectJson
                            (Decode.at [ "data", "duration" ] Decode.float
                                |> Decode.map Basics.floor
                                |> Decode.map Duration.fromSeconds
                            )
                    , headers = [ ( "Authorization", "Basic " ++ authToken ) ]
                    , cacheStrategy = Nothing
                    , retries = Nothing
                    , timeoutInMs = Nothing
                    , cachePath = Nothing
                    }
                    |> BackendTask.allowFatal
            )


currentChapterMuxId : RouteParams -> BackendTask FatalError { assetId : String, playbackId : String }
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


courseChapters : RouteParams -> BackendTask FatalError (List Metadata)
courseChapters current =
    pages
        |> BackendTask.andThen
            (\allPages ->
                allPages
                    |> List.filterMap
                        (\chapter ->
                            if chapter.course == current.course then
                                (findFilePath chapter
                                    |> BackendTask.andThen
                                        (\filePath -> metadata filePath chapter)
                                )
                                    |> Just

                            else
                                Nothing
                        )
                    |> BackendTask.combine
            )


pages : BackendTask FatalError (List RouteParams)
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
        |> Glob.toBackendTask
        |> BackendTask.map
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


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    findFilePath routeParams
        |> BackendTask.andThen
            (\filePath ->
                BackendTask.map3
                    (\meta bh chapters ->
                        { metadata = meta
                        , body = bh.body
                        , highlights = bh.highlights
                        , chapters = chapters
                        }
                    )
                    (metadata filePath routeParams)
                    (MarkdownCodec.bodyAndHighlights filePath)
                    (courseChapters routeParams)
            )


metadata : String -> RouteParams -> BackendTask FatalError Metadata
metadata filePath routeParams =
    BackendTask.map2
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
            |> BackendTask.File.onlyFrontmatter
                (Decode.map3
                    (\title description free ->
                        { title = title
                        , description = description
                        , free = free
                        }
                    )
                    (Decode.field "title" Decode.string)
                    (Decode.field "description" Decode.string)
                    (Decode.maybe (Decode.field "free" Decode.bool) |> Decode.map (Maybe.withDefault False))
                )
            |> BackendTask.allowFatal
        )
        (routeParams
            |> currentChapterMuxId
            |> BackendTask.andThen
                (\info ->
                    muxIdToDuration info.assetId
                        |> BackendTask.map
                            (\duration ->
                                { playbackId = info.playbackId
                                , duration = duration
                                }
                            )
                )
        )


findFilePath : RouteParams -> BackendTask FatalError String
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
        |> BackendTask.allowFatal


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Cloudinary.url "v1636406821/elm-ts-interop-course.svg" Nothing 600
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = app.data.metadata.description
        , locale = Nothing
        , title = "elm-ts-interop course - " ++ app.data.metadata.title
        }
        |> Seo.website


type alias Data =
    { metadata : Metadata
    , body : String
    , highlights : Dict String Shiki.Highlighted
    , chapters : List Metadata
    }


goProView : Html msg
goProView =
    Html.div []
        [ Html.text "Go pro to see this video"
        ]


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app sharedModel =
    let
        loggedInSubscriber =
            sharedModel.user |> Maybe.map .isPro |> Maybe.withDefault False
    in
    { title = ""
    , body =
        View.Tailwind
            [ titleView app.data.metadata.title
                |> freeze
            , if app.data.metadata.free || loggedInSubscriber then
                Html.Keyed.node "div"
                    [ classes
                        [ Tw.flex
                        , Tw.raw "justify-around"
                        , Tw.grow
                        ]
                    ]
                    [ ( "my-player-" ++ app.routeParams.section
                      , Html.Keyed.node "hls-video"
                            [ Attr.id <| "my-player-" ++ app.routeParams.section
                            , Attr.src <| "/.netlify/functions/sign_playback_id?playbackId=" ++ app.data.metadata.playbackId
                            , Attr.controls True
                            , Attr.attribute "preload" "auto"
                            , Attr.attribute "lesson-id" (app.routeParams.course ++ "/" ++ app.routeParams.section)
                            , Attr.attribute "title" app.data.metadata.title
                            , Attr.attribute "duration" (Duration.inMillis app.data.metadata.duration |> String.fromInt)
                            , Attr.attribute "series" app.routeParams.course
                            , classes
                                [ lg [ Tw.raw "w-[800px] h-[450px]" ]
                                , md [ Tw.raw "w-[600px] h-[337.5px]" ]
                                , sm [ Tw.raw "w-[500px] h-[281.25px]" ]
                                , Tw.raw "w-[300px] h-[168.75px]"
                                , Tw.mb s6
                                ]
                            ]
                            []
                      )
                    ]

              else
                goProView
            , nextPreviousView app.data.metadata app.data.chapters
                |> freeze
            , chaptersView app.data.metadata app.data.chapters
                |> freeze
            , Html.div
                [ classes
                    [ Tw.mt s12
                    ]
                ]
                (subTitleView "Chapter Notes"
                    :: (MarkdownCodec.renderMarkdown (TailwindMarkdownViewRenderer.renderer app.data.highlights) app.data.body
                            |> Result.withDefault [ Html.text "Error rendering markdown" ]
                       )
                )
                |> freeze
            ]
    }


titleView : String -> Html msg
titleView titleText =
    Html.h1
        [ classes
            [ Tw.raw "text-4xl"
            , Tw.raw "font-bold"
            , Tw.raw "tracking-tight"
            , Tw.mt s2
            , Tw.mb s8
            , Tw.raw "font-raleway"
            , Tw.raw "text-foreground-strong"
            ]
        ]
        [ Html.text titleText ]


subTitleView : String -> Html msg
subTitleView titleText =
    Html.h2
        [ classes
            [ Tw.raw "text-3xl"
            , Tw.raw "font-bold"
            , Tw.raw "tracking-tight"
            , Tw.mt s2
            , Tw.mb s8
            , Tw.raw "font-raleway"
            , Tw.raw "text-foreground-strong"
            ]
        ]
        [ Html.text titleText ]


nextPreviousView : Metadata -> List Metadata -> Html msg
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
        [ classes
            [ Tw.mb s6
            , Tw.flex
            , Tw.justify_between
            , Tw.flex_col
            , md
                [ Tw.flex_row
                ]
            , Tw.w_full
            , Tw.raw "gap-2"
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


nextPreviousButton : NextOrPrevious -> Maybe Metadata -> Html msg
nextPreviousButton kind maybeNextOrPrevious =
    maybeNextOrPrevious
        |> Maybe.map
            (\nextOrPrevious ->
                Route.Courses__Course___Section_ nextOrPrevious.routeParams
                    |> Link.htmlLink2
                        [ classes
                            [ Tw.raw "hover:bg-foreground-strong"
                            , Tw.raw "hover:underline"
                            , Tw.px s4
                            , Tw.py s2
                            , Tw.raw "bg-foreground"
                            , Tw.text_simple background
                            , Tw.raw "rounded-lg"
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


chaptersView : Metadata -> List Metadata -> Html msg
chaptersView current chapters =
    Html.ol []
        (chapters |> List.indexedMap (chapterView current))


chapterView : Metadata -> Int -> Metadata -> Html msg
chapterView currentPage index chapter =
    Html.li
        [ classes
            [ if currentPage.routeParams == chapter.routeParams then
                Tw.bg_simple accent1

              else
                Tw.bg_simple background
            , Tw.raw "hover:bg-accent1"
            ]
        ]
        [ Route.Courses__Course___Section_ chapter.routeParams
            |> Link.htmlLink2
                [ classes
                    [ Tw.flex
                    , Tw.justify_between
                    , Tw.p s2
                    ]
                ]
                [ Html.div
                    [ classes
                        [ Tw.raw "gap-3"
                        , Tw.flex
                        ]
                    ]
                    [ Html.span
                        []
                        [ Html.text <| String.fromInt (index + 1) ++ ". " ]
                    , Html.span
                        [ classes
                            [ Tw.raw "text-foreground-strong"
                            , Tw.raw "font-bold"
                            ]
                        ]
                        [ Html.text (chapter.title ++ " ") ]
                    ]
                , Duration.view
                    [ classes
                        [ Tw.py s1
                        , Tw.px s2
                        , Tw.raw "bg-foreground-strong"
                        , Tw.raw "rounded-xl"
                        , Tw.text_simple background
                        , Tw.raw "text-sm"
                        ]
                    ]
                    chapter.duration
                ]
        ]

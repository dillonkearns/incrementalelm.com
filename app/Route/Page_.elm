module Route.Page_ exposing (ActionData, BackRef, Data, Metadata, Model, Msg, NoteRecord, PageMetadata, RouteParams, route)

{- Fauna DB view tracking has been removed since Fauna GraphQL is dead. -}

import BackendTask exposing (BackendTask)
import BackendTask.File
import BackendTask.Glob as Glob
import Date exposing (Date)
import Dict exposing (Dict)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html exposing (..)
import Html.Attributes as Attr
import Json.Decode as Decode exposing (Decoder)
import Link
import Markdown.Block as Block exposing (Block)
import Markdown.Parser
import MarkdownCodec
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Regex
import Route exposing (Route)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import Shiki
import String.Extra
import Tailwind as Tw exposing (classes)
import Tailwind.Breakpoints exposing (lg)
import Tailwind.Theme exposing (s12, s2, s3, s5, s6, s8)
import TailwindMarkdownViewRenderer
import Time
import Timestamps exposing (Timestamps)
import UnsplashImage exposing (UnsplashImage)
import View exposing (View, freeze)
import Widget.Signup


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { page : String }


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


pages : BackendTask FatalError (List RouteParams)
pages =
    Glob.succeed RouteParams
        |> Glob.match (Glob.oneOf ( ( "garden/", () ), [ ( "content/page/", () ) ] ))
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask
        |> BackendTask.map
            (List.filter
                (\value -> value.page /= "index")
            )


type PageKind
    = Page
    | NotePage


findFilePath : String -> BackendTask FatalError ( String, PageKind )
findFilePath slug =
    Glob.succeed Tuple.pair
        |> Glob.captureFilePath
        |> Glob.capture (Glob.oneOf ( ( "content/page/", Page ), [ ( "garden/", NotePage ) ] ))
        |> Glob.match (Glob.literal slug)
        |> Glob.match (Glob.literal ".md")
        |> Glob.expectUniqueMatch
        |> BackendTask.allowFatal


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    findFilePath routeParams.page
        |> BackendTask.andThen
            (\( filePath, pageKind ) ->
                case pageKind of
                    NotePage ->
                        BackendTask.map2
                            (\( meta, bh, info ) noteRecord ->
                                { metadata = meta
                                , body = bh.body
                                , highlights = bh.highlights
                                , info = info
                                , noteData = Just noteRecord
                                }
                            )
                            (BackendTask.map3
                                (\a b c -> ( a, b, c ))
                                (BackendTask.File.onlyFrontmatter decoder filePath |> BackendTask.allowFatal)
                                (MarkdownCodec.bodyAndHighlights filePath)
                                (MarkdownCodec.titleAndDescription filePath)
                            )
                            (BackendTask.map3 NoteRecord
                                (backReferences routeParams.page)
                                (forwardRefs routeParams.page)
                                (Timestamps.data filePath)
                            )

                    Page ->
                        BackendTask.map3
                            (\meta bh info ->
                                { metadata = meta
                                , body = bh.body
                                , highlights = bh.highlights
                                , info = info
                                , noteData = Nothing
                                }
                            )
                            (BackendTask.File.onlyFrontmatter decoder filePath |> BackendTask.allowFatal)
                            (MarkdownCodec.bodyAndHighlights filePath)
                            (MarkdownCodec.titleAndDescription filePath)
            )


type alias Metadata =
    { cover : Maybe UnsplashImage
    , publishedAt : Maybe Date
    }


type alias Data =
    { metadata : Metadata
    , body : String
    , highlights : Dict String Shiki.Highlighted
    , info : { title : String, description : String }
    , noteData : Maybe NoteRecord
    }


type alias NoteRecord =
    { backReferences : List BackRef
    , forwardReferences : List BackRef
    , timestamps : Timestamps
    }


formatDate : Date -> String
formatDate =
    Date.format "MMMM dd, y"


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app sharedModel =
    { title = app.data.info.title
    , body =
        View.Tailwind
            [ [ div
                    [ classes
                        [ Tw.raw "text-xs"
                        ]
                    ]
                    [ div
                        []
                        [ viewIf app.data.noteData
                            (\note ->
                                case app.data.metadata.publishedAt of
                                    Just publishDate ->
                                        text <| "Published " ++ formatDate publishDate

                                    Nothing ->
                                        text <|
                                            "Created "
                                                ++ (note.timestamps.created
                                                        |> Date.fromPosix Time.utc
                                                        |> formatDate
                                                   )
                            )
                        ]
                    , div []
                        [ viewIf app.data.noteData
                            (\note ->
                                let
                                    publishedOrCreatedDate : Date
                                    publishedOrCreatedDate =
                                        app.data.metadata.publishedAt
                                            |> Maybe.withDefault
                                                (note.timestamps.created
                                                    |> Date.fromPosix Time.utc
                                                )
                                in
                                if Date.compare publishedOrCreatedDate (note.timestamps.updated |> Date.fromPosix Time.utc) == GT then
                                    text ""

                                else
                                    text <|
                                        "Updated "
                                            ++ (note.timestamps.updated
                                                    |> Date.fromPosix Time.utc
                                                    |> formatDate
                                               )
                            )
                        ]
                    ]
              , (MarkdownCodec.renderMarkdown (TailwindMarkdownViewRenderer.renderer app.data.highlights) app.data.body
                    |> Result.withDefault [ text "Error rendering markdown" ]
                )
                    |> div [ classes [ Tw.flex, Tw.flex_col ] ]
              , div [ classes [ Tw.my s8 ] ] [ Widget.Signup.view ]
              , viewIf app.data.noteData
                    (\note ->
                        div
                            []
                            [ backReferencesView "Notes that link here" note.backReferences
                            , backReferencesView "Links on this page" note.forwardReferences
                            ]
                    )
              , if app.data.noteData /= Nothing then
                    node "utterances-comments" [] []

                else
                    text ""
              ]
                |> div []
                |> freeze
            ]
    }


viewIf : Maybe a -> (a -> Html msg) -> Html msg
viewIf maybeData dataToView =
    Maybe.map dataToView maybeData
        |> Maybe.withDefault (text "")


backReferencesView : String -> List BackRef -> Html msg
backReferencesView title backRefs =
    if List.isEmpty backRefs then
        text ""

    else
        div []
            [ h2 [] [ text title ]
            , backReferencesView_ backRefs
            ]


backReferencesView_ : List BackRef -> Html msg
backReferencesView_ allBackRefs =
    div
        [ classes
            [ Tw.mt s12
            , Tw.raw "max-w-lg"
            , Tw.raw "mx-auto"
            , Tw.grid
            , Tw.raw "gap-5"
            , lg
                [ Tw.raw "grid-cols-2"
                , Tw.raw "max-w-none"
                ]
            ]
        ]
        (allBackRefs
            |> List.map
                (\backReference ->
                    blogCard (Route.Page_ { page = backReference.slug }) backReference
                )
        )


blogCard : Route -> { a | title : String, description : String } -> Html msg
blogCard cardRoute info =
    cardRoute
        |> Link.htmlLink
            [ classes
                [ Tw.flex
                , Tw.flex_col
                , Tw.raw "rounded-lg"
                , Tw.raw "shadow-lg"
                , Tw.overflow_hidden
                ]
            ]
            (div
                [ classes
                    [ Tw.raw "flex-1"
                    , Tw.raw "bg-white"
                    , Tw.p s6
                    , Tw.flex
                    , Tw.flex_col
                    , Tw.justify_between
                    ]
                ]
                [ div
                    [ classes
                        [ Tw.raw "flex-1"
                        ]
                    ]
                    [ span
                        [ classes
                            [ Tw.block
                            , Tw.mt s2
                            ]
                        ]
                        [ p
                            [ classes
                                [ Tw.raw "text-xl"
                                , Tw.raw "font-semibold"
                                , Tw.raw "text-gray-900"
                                ]
                            ]
                            [ text info.title ]
                        , p
                            [ classes
                                [ Tw.mt s3
                                , Tw.raw "text-base"
                                , Tw.raw "text-gray-500"
                                ]
                            ]
                            [ info.description
                                |> String.Extra.softEllipsis 160
                                |> text
                            ]
                        ]
                    ]
                ]
            )


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = "Incremental Elm"
        , image =
            { url =
                app.data.metadata.cover
                    |> Maybe.withDefault UnsplashImage.default
                    |> UnsplashImage.rawUrl
                    |> Pages.Url.external
            , alt = app.data.info.title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = app.data.info.description
        , title = app.data.info.title
        , locale = Nothing
        }
        |> Seo.website


type alias PageMetadata =
    { description : Maybe String
    , image : Maybe UnsplashImage
    }


decoder : Decoder Metadata
decoder =
    Decode.map2 Metadata
        (Decode.maybe (Decode.field "cover" UnsplashImage.decoder))
        (Decode.maybe
            (Decode.field
                "publishAt"
                (Decode.string
                    |> Decode.andThen
                        (\isoString ->
                            case Date.fromIsoString isoString of
                                Ok date ->
                                    Decode.succeed date

                                Err error ->
                                    Decode.fail error
                        )
                )
            )
        )


type alias Note =
    { route : Route
    , slug : String
    , title : String
    }


type alias BackRef =
    { slug : String
    , title : String
    , description : String
    }


notes : BackendTask FatalError (List { topic : String, filePath : String })
notes =
    Glob.succeed
        (\topic filePath -> { topic = topic, filePath = filePath })
        |> Glob.match (Glob.literal "garden/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.captureFilePath
        |> Glob.toBackendTask
        |> BackendTask.map (List.filter (\value -> value.topic /= "index"))


backReferences : String -> BackendTask FatalError (List BackRef)
backReferences slug =
    notes
        |> BackendTask.andThen
            (\allNotes ->
                allNotes
                    |> List.map
                        (\note ->
                            BackendTask.File.bodyWithoutFrontmatter ("garden/" ++ note.topic ++ ".md")
                                |> BackendTask.allowFatal
                                |> BackendTask.andThen
                                    (\rawMarkdown ->
                                        rawMarkdown
                                            |> Markdown.Parser.parse
                                            |> Result.map
                                                (\blocks ->
                                                    if hasReferenceTo slug blocks then
                                                        MarkdownCodec.titleAndDescription note.filePath
                                                            |> BackendTask.map
                                                                (\{ title, description } -> BackRef note.topic title description)
                                                            |> Just

                                                    else
                                                        Nothing
                                                )
                                            |> Result.withDefault Nothing
                                            |> Maybe.map (BackendTask.map Just)
                                            |> Maybe.withDefault (BackendTask.succeed Nothing)
                                    )
                        )
                    |> BackendTask.combine
                    |> BackendTask.map (List.filterMap identity)
            )


forwardRefs : String -> BackendTask FatalError (List BackRef)
forwardRefs slug =
    BackendTask.File.bodyWithoutFrontmatter ("garden/" ++ slug ++ ".md")
        |> BackendTask.allowFatal
        |> BackendTask.andThen
            (\rawMarkdown ->
                rawMarkdown
                    |> Markdown.Parser.parse
                    |> Result.map
                        (\blocks ->
                            blocks
                                |> forwardReferences
                        )
                    |> Result.withDefault []
                    |> BackendTask.combine
            )


hasReferenceTo : String -> List Block -> Bool
hasReferenceTo slug blocks =
    blocks
        |> Block.inlineFoldl
            (\inline links ->
                case inline of
                    Block.Link str _ _ ->
                        if str == slug then
                            True

                        else
                            links

                    _ ->
                        links
            )
            False


forwardReferences : List Block -> List (BackendTask FatalError BackRef)
forwardReferences blocks =
    blocks
        |> Block.inlineFoldl
            (\inline links ->
                case inline of
                    Block.Link rawSlug _ _ ->
                        let
                            cleanSlug : String
                            cleanSlug =
                                rawSlug
                                    |> Regex.replace (Regex.fromString "^/" |> Maybe.withDefault Regex.never) (\_ -> "")
                                    |> Regex.replace (Regex.fromString "/$" |> Maybe.withDefault Regex.never) (\_ -> "")
                                    |> Regex.replace (Regex.fromString "#.*" |> Maybe.withDefault Regex.never) (\_ -> "")
                        in
                        if isWikiLink cleanSlug then
                            (MarkdownCodec.titleAndDescription ("garden/" ++ cleanSlug ++ ".md")
                                |> BackendTask.map
                                    (\{ title, description } -> BackRef cleanSlug title description)
                            )
                                :: links

                        else
                            links

                    _ ->
                        links
            )
            []


isWikiLink : String -> Bool
isWikiLink destination =
    not (destination |> String.startsWith "http")

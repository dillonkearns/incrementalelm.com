module Page.Notes.Topic_ exposing (BackRef, Data, Model, Msg, PageMetadata, RouteParams, page)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Element exposing (Element)
import Head
import Markdown.Block as Block exposing (Block)
import Markdown.Parser
import MarkdownCodec
import MarkdownRenderer
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import Route exposing (Route)
import Serialize
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { topic : String }


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
    Glob.succeed RouteParams
        |> Glob.match (Glob.literal "content/notes/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


data : RouteParams -> DataSource Data
data routeParams =
    let
        filePath : String
        filePath =
            "content/notes/" ++ routeParams.topic ++ ".md"
    in
    DataSource.map4
        Data
        (DataSource.File.onlyFrontmatter decoder filePath)
        (MarkdownCodec.withoutFrontmatter MarkdownRenderer.renderer filePath)
        (MarkdownCodec.noteTitle filePath)
        (backReferences routeParams.topic)


type alias Data =
    { metadata : PageMetadata
    , body : List (Element Msg)
    , title : String
    , backReferences : List BackRef
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.title
    , body =
        static.data.body
            ++ [ backReferencesView static.data.backReferences ]
    }


backReferencesView : List BackRef -> Element msg
backReferencesView backRefs =
    Element.column []
        (backRefs
            |> List.map
                (\backReference ->
                    Element.link []
                        { url = Route.Notes__Topic_ { topic = backReference.slug } |> Route.toPath |> Path.toAbsolute
                        , label = Element.text backReference.title
                        }
                )
        )


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    --Seo.summaryLarge
    --    { canonicalUrlOverride = Nothing
    --    , siteName = "Incremental Elm"
    --    , image =
    --        { url = static.data.metadata.image |> Maybe.withDefault (Pages.Url.external "")
    --        , alt = static.data.title
    --        , dimensions = Nothing
    --        , mimeType = Nothing
    --        }
    --    , description = static.data.metadata.description |> Maybe.withDefault static.data.title
    --    , title = static.data.title
    --    , locale = Nothing
    --    }
    --    |> Seo.website
    []


type alias PageMetadata =
    { description : Maybe String
    , image : Maybe Pages.Url.Url
    }


decoder : Decoder PageMetadata
decoder =
    Decode.map2 PageMetadata
        (Decode.maybe (Decode.field "description" Decode.string))
        (Decode.maybe (Decode.field "image" imageDecoder))


imageDecoder : Decoder Pages.Url.Url
imageDecoder =
    Decode.string
        |> Decode.map
            (\src ->
                [ "images", src ]
                    |> Path.join
                    |> Pages.Url.fromPath
            )


type alias Note =
    { route : Route
    , slug : String
    , title : String
    }


type alias BackRef =
    { slug : String, title : String }


notes : DataSource (List BackRef)
notes =
    Glob.succeed
        (\topic ->
            noteTitle topic
                |> DataSource.map
                    (BackRef topic)
        )
        |> Glob.match (Glob.literal "content/notes/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource
        |> DataSource.resolve


backReferences : String -> DataSource (List BackRef)
backReferences slug =
    notes
        |> DataSource.map
            (\allNotes ->
                allNotes
                    |> List.map
                        (\note ->
                            DataSource.File.bodyWithoutFrontmatter ("content/notes/" ++ note.slug ++ ".md")
                                |> DataSource.andThen
                                    (\rawMarkdown ->
                                        rawMarkdown
                                            |> Markdown.Parser.parse
                                            |> Result.map
                                                (\blocks ->
                                                    if hasReferenceTo slug blocks then
                                                        Just note

                                                    else
                                                        Nothing
                                                )
                                            |> Result.mapError (\_ -> "Markdown error")
                                            |> DataSource.fromResult
                                    )
                        )
            )
        |> DataSource.resolve
        |> DataSource.map (List.filterMap identity)
        |> DataSource.distillSerializeCodec "backrefs" (Serialize.list serializeBackRef)


serializeBackRef : Serialize.Codec e { slug : String, title : String }
serializeBackRef =
    Serialize.record BackRef
        |> Serialize.field .slug Serialize.string
        |> Serialize.field .title Serialize.string
        |> Serialize.finishRecord


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


noteTitle : String -> DataSource String
noteTitle slug =
    DataSource.File.bodyWithoutFrontmatter ("content/notes/" ++ slug ++ ".md")
        |> DataSource.andThen
            (\rawContent ->
                Markdown.Parser.parse rawContent
                    |> Result.mapError (\_ -> "Markdown error")
                    |> Result.map
                        (\blocks ->
                            Block.foldl
                                (\block maxSoFar ->
                                    case block of
                                        Block.Heading level inlines ->
                                            if level == Block.H1 then
                                                Just (Block.extractInlineText inlines)

                                            else
                                                maxSoFar

                                        _ ->
                                            maxSoFar
                                )
                                Nothing
                                blocks
                        )
                    |> Result.andThen (Result.fromMaybe "Expected to find an H1 heading")
                    |> DataSource.fromResult
            )
        |> DataSource.distillSerializeCodec ("note-title-" ++ slug) Serialize.string

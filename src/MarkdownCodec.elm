module MarkdownCodec exposing (bodyAndHighlights, isPlaceholder, noteTitle, renderMarkdown, titleAndDescription, withFrontmatter, withFrontmatterResolved, withoutFrontmatter, withoutFrontmatterResolved)

import BackendTask exposing (BackendTask)
import BackendTask.Custom
import BackendTask.File as StaticFile
import Dict exposing (Dict)
import FatalError exposing (FatalError)
import Json.Decode as Decode
import Json.Encode
import List.Extra
import Markdown.Block as Block exposing (Block)
import Markdown.Parser
import Markdown.Renderer
import MarkdownExtra
import Shiki


isPlaceholder : String -> BackendTask FatalError (Maybe ())
isPlaceholder filePath =
    filePath
        |> StaticFile.bodyWithoutFrontmatter
        |> BackendTask.allowFatal
        |> BackendTask.andThen
            (\rawContent ->
                Markdown.Parser.parse rawContent
                    |> Result.mapError (\_ -> "Markdown error")
                    |> Result.map
                        (\blocks ->
                            List.any
                                (\block ->
                                    case block of
                                        Block.Heading _ _ ->
                                            False

                                        _ ->
                                            True
                                )
                                blocks
                                |> not
                        )
                    |> resultToBackendTask
            )
        |> BackendTask.map
            (\bool ->
                if bool then
                    Nothing

                else
                    Just ()
            )


noteTitle : String -> BackendTask FatalError String
noteTitle filePath =
    titleFromFrontmatter filePath
        |> BackendTask.andThen
            (\maybeTitle ->
                maybeTitle
                    |> Maybe.map BackendTask.succeed
                    |> Maybe.withDefault
                        (StaticFile.bodyWithoutFrontmatter filePath
                            |> BackendTask.allowFatal
                            |> BackendTask.andThen
                                (\rawContent ->
                                    Markdown.Parser.parse rawContent
                                        |> Result.mapError (\_ -> "Markdown error")
                                        |> Result.map
                                            (\blocks ->
                                                List.Extra.findMap
                                                    (\block ->
                                                        case block of
                                                            Block.Heading Block.H1 inlines ->
                                                                Just (Block.extractInlineText inlines)

                                                            _ ->
                                                                Nothing
                                                    )
                                                    blocks
                                            )
                                        |> Result.andThen (Result.fromMaybe <| "Expected to find an H1 heading for page " ++ filePath)
                                        |> resultToBackendTask
                                )
                        )
            )


titleAndDescription : String -> BackendTask FatalError { title : String, description : String }
titleAndDescription filePath =
    filePath
        |> StaticFile.onlyFrontmatter
            (Decode.map2 (\title description -> { title = title, description = description })
                (optionalField "title" Decode.string)
                (optionalField "description" Decode.string)
            )
        |> BackendTask.allowFatal
        |> BackendTask.andThen
            (\metadata ->
                Maybe.map2 (\title description -> { title = title, description = description })
                    metadata.title
                    metadata.description
                    |> Maybe.map BackendTask.succeed
                    |> Maybe.withDefault
                        (StaticFile.bodyWithoutFrontmatter filePath
                            |> BackendTask.allowFatal
                            |> BackendTask.andThen
                                (\rawContent ->
                                    Markdown.Parser.parse rawContent
                                        |> Result.mapError (\_ -> "Markdown error")
                                        |> Result.map
                                            (\blocks ->
                                                Maybe.map
                                                    (\title ->
                                                        { title = title
                                                        , description =
                                                            case metadata.description of
                                                                Just description ->
                                                                    description

                                                                Nothing ->
                                                                    findDescription blocks
                                                        }
                                                    )
                                                    (case metadata.title of
                                                        Just title ->
                                                            Just title

                                                        Nothing ->
                                                            findH1 blocks
                                                    )
                                            )
                                        |> Result.andThen (Result.fromMaybe <| "Expected to find an H1 heading for page " ++ filePath)
                                        |> resultToBackendTask
                                )
                        )
            )


findH1 : List Block -> Maybe String
findH1 blocks =
    List.Extra.findMap
        (\block ->
            case block of
                Block.Heading Block.H1 inlines ->
                    Just (Block.extractInlineText inlines)

                _ ->
                    Nothing
        )
        blocks


findDescription : List Block -> String
findDescription blocks =
    blocks
        |> List.Extra.findMap
            (\block ->
                case block of
                    Block.Paragraph inlines ->
                        Just (MarkdownExtra.extractInlineText inlines)

                    _ ->
                        Nothing
            )
        |> Maybe.withDefault ""


titleFromFrontmatter : String -> BackendTask FatalError (Maybe String)
titleFromFrontmatter filePath =
    StaticFile.onlyFrontmatter
        (optionalField "title" Decode.string)
        filePath
        |> BackendTask.allowFatal


withoutFrontmatter :
    Markdown.Renderer.Renderer view
    -> String
    -> BackendTask FatalError (List view)
withoutFrontmatter renderer filePath =
    filePath
        |> StaticFile.bodyWithoutFrontmatter
        |> BackendTask.allowFatal
        |> BackendTask.andThen
            (\rawBody ->
                rawBody
                    |> Markdown.Parser.parse
                    |> Result.mapError (\_ -> "Couldn't parse markdown.")
                    |> resultToBackendTask
            )
        |> BackendTask.andThen
            (\blocks ->
                blocks
                    |> Markdown.Renderer.render renderer
                    |> resultToBackendTask
            )


withFrontmatter :
    (frontmatter -> List view -> value)
    -> Decode.Decoder frontmatter
    -> Markdown.Renderer.Renderer view
    -> String
    -> BackendTask FatalError value
withFrontmatter constructor frontmatterDecoder renderer filePath =
    BackendTask.map2 constructor
        (StaticFile.onlyFrontmatter
            frontmatterDecoder
            filePath
            |> BackendTask.allowFatal
        )
        (StaticFile.bodyWithoutFrontmatter
            filePath
            |> BackendTask.allowFatal
            |> BackendTask.andThen
                (\rawBody ->
                    rawBody
                        |> Markdown.Parser.parse
                        |> Result.mapError (\_ -> "Couldn't parse markdown.")
                        |> resultToBackendTask
                )
            |> BackendTask.andThen
                (\blocks ->
                    blocks
                        |> Markdown.Renderer.render renderer
                        |> resultToBackendTask
                )
        )


withFrontmatterResolved :
    (frontmatter -> List view -> value)
    -> Decode.Decoder frontmatter
    -> Markdown.Renderer.Renderer (BackendTask FatalError view)
    -> String
    -> BackendTask FatalError value
withFrontmatterResolved constructor frontmatterDecoder renderer filePath =
    BackendTask.map2 constructor
        (StaticFile.onlyFrontmatter
            frontmatterDecoder
            filePath
            |> BackendTask.allowFatal
        )
        (withoutFrontmatterResolved renderer filePath)


withoutFrontmatterResolved :
    Markdown.Renderer.Renderer (BackendTask FatalError view)
    -> String
    -> BackendTask FatalError (List view)
withoutFrontmatterResolved renderer filePath =
    withoutFrontmatter renderer filePath
        |> BackendTask.andThen BackendTask.combine


resultToBackendTask : Result String a -> BackendTask FatalError a
resultToBackendTask result =
    case result of
        Ok value ->
            BackendTask.succeed value

        Err error ->
            BackendTask.fail (FatalError.fromString error)


optionalField : String -> Decode.Decoder a -> Decode.Decoder (Maybe a)
optionalField fieldName decoder =
    Decode.maybe (Decode.field fieldName decoder)


bodyAndHighlights : String -> BackendTask FatalError { body : String, highlights : Dict String Shiki.Highlighted }
bodyAndHighlights filePath =
    StaticFile.bodyWithoutFrontmatter filePath
        |> BackendTask.allowFatal
        |> BackendTask.andThen
            (\body ->
                extractCodeBlocks body
                    |> List.map
                        (\info ->
                            highlightCodeBlock info
                                |> BackendTask.map (\highlighted -> ( info.body, highlighted ))
                        )
                    |> BackendTask.combine
                    |> BackendTask.map
                        (\pairs ->
                            { body = body
                            , highlights = Dict.fromList pairs
                            }
                        )
            )


renderMarkdown :
    Markdown.Renderer.Renderer view
    -> String
    -> Result String (List view)
renderMarkdown markdownRenderer body =
    body
        |> Markdown.Parser.parse
        |> Result.mapError (\_ -> "Markdown parsing error")
        |> Result.andThen (Markdown.Renderer.render markdownRenderer)


extractCodeBlocks : String -> List { body : String, language : Maybe String }
extractCodeBlocks rawBody =
    rawBody
        |> Markdown.Parser.parse
        |> Result.withDefault []
        |> List.filterMap
            (\block ->
                case block of
                    Block.CodeBlock { body, language } ->
                        Just { body = body, language = language }

                    _ ->
                        Nothing
            )


highlightCodeBlock : { body : String, language : Maybe String } -> BackendTask FatalError Shiki.Highlighted
highlightCodeBlock info =
    BackendTask.Custom.run "highlight"
        (Json.Encode.object
            [ ( "body", Json.Encode.string info.body )
            , ( "language"
              , info.language
                    |> Maybe.map Json.Encode.string
                    |> Maybe.withDefault Json.Encode.null
              )
            ]
        )
        Shiki.decoder
        |> BackendTask.allowFatal

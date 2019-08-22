module Pages.Document exposing (..)

import Dict exposing (Dict)
import Html exposing (Html)
import Mark
import Mark.Error


type alias Document metadata view =
    Dict String
        { frontmatterParser : String -> metadata
        , contentParser : String -> view
        }


init : Document metadata view
init =
    Dict.empty


withMarkup :
    (Html msg -> view)
    -> Mark.Document metadata
    -> Mark.Document view
    -> Document metadata view
    -> Document metadata view
withMarkup toView metadataParser markBodyParser document =
    Dict.insert "emu"
        { contentParser = renderMarkup toView markBodyParser
        , frontmatterParser =
            \frontMatter ->
                Mark.compile metadataParser
                    frontMatter
                    |> (\outcome ->
                            case outcome of
                                Mark.Success parsedMetadata ->
                                    parsedMetadata

                                Mark.Failure failure ->
                                    Debug.todo "Failure"

                                -- Metadata.Page { title = "Failure TODO" }
                                Mark.Almost failure ->
                                    Debug.todo "Almost failure"
                        -- Metadata.Page { title = "Almost Failure TODO" }
                       )
        }
        document


renderMarkup : (Html msg -> view) -> Mark.Document view -> String -> view
renderMarkup toView markBodyParser markupBody =
    Mark.compile
        -- TODO pass in static data for image assets and routes
        markBodyParser
        (markupBody |> String.trimLeft)
        |> (\outcome ->
                case outcome of
                    Mark.Success renderedView ->
                        renderedView

                    Mark.Failure failure ->
                        failure
                            |> List.map (Mark.Error.toHtml Mark.Error.Light)
                            |> Html.div []
                            |> toView

                    Mark.Almost failure ->
                        Html.text "TODO almost failure"
                            |> toView
           )


parseMetadata :
    Document metadata view
    -> List ( List String, { extension : String, frontMatter : String, body : Maybe String } )
    -> List ( List String, Result String { extension : String, metadata : metadata } )
parseMetadata document content =
    content
        |> List.map
            (Tuple.mapSecond
                (\{ frontMatter, extension } ->
                    let
                        maybeDocumentEntry =
                            Dict.get extension document
                    in
                    case maybeDocumentEntry of
                        Just documentEntry ->
                            { metadata = documentEntry.frontmatterParser frontMatter
                            , extension = extension
                            }
                                |> Ok

                        Nothing ->
                            Err ("Could not find extension '" ++ extension ++ "'")
                )
            )


parseContent :
    String
    -> String
    -> Document metadata view
    -> Result String view
parseContent extension body document =
    let
        maybeDocumentEntry =
            Dict.get extension document
    in
    case maybeDocumentEntry of
        Just documentEntry ->
            documentEntry.contentParser body
                |> Ok

        Nothing ->
            Err ("Could not find extension '" ++ extension ++ "'")

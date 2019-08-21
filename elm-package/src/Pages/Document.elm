module Pages.Document exposing (..)

import Dict exposing (Dict)


type alias Document metadata view =
    Dict String
        { frontmatterParser : String -> metadata
        , contentParser : String -> view
        }


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

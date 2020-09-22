module Metadata exposing (ArticleMetadata, GlossaryMetadata, LearnMetadata, Metadata(..), decoder)

import Dict exposing (Dict)
import Element exposing (Element)
import Element.Font as Font
import Json.Decode as Decode exposing (Decoder)


type Metadata msg
    = Page { title : String, description : Maybe String }
    | Article (ArticleMetadata msg)
    | Learn LearnMetadata
    | Glossary GlossaryMetadata


type alias LearnMetadata =
    { title : String }


type alias GlossaryMetadata =
    { title : String, description : String }


type alias ArticleMetadata msg =
    { title : { styled : List (Element msg), raw : String }
    , description : { styled : List (Element msg), raw : String }
    , coverImage : String
    }


articleDecoder : Decoder (ArticleMetadata msg)
articleDecoder =
    Decode.map3 ArticleMetadata
        (Decode.field "title" markdownString)
        (Decode.field "description" markdownString)
        (Decode.field "src"
            (Decode.string |> Decode.map (\src -> "/images/" ++ src))
        )


learnDecoder : Decoder LearnMetadata
learnDecoder =
    Decode.map LearnMetadata
        (Decode.field "title" Decode.string)


markdownString : Decoder { styled : List (Element msg), raw : String }
markdownString =
    Decode.string
        |> Decode.andThen
            (\string ->
                Decode.succeed
                    { styled = [ Element.text string ]
                    , raw = string
                    }
            )



--(Decode.field "title" Decode.string) |> Decode.map (\title -> Page { title = title })


decoder : Decoder (Metadata msg)
decoder =
    Decode.oneOf
        [ Decode.field "type" Decode.string
            |> Decode.andThen
                (\type_ ->
                    case type_ of
                        {-

                           "type": "article",
                           "title": "Moving Faster with Tiny Steps in Elm",
                           "src": "article-cover/mountains.jpg",
                           "description": "In this post, we're going to be looking up an Article in an Elm Dict, using the tiniest steps possible."
                        -}
                        "page" ->
                            Decode.map2 (\title description -> Page { title = title, description = description })
                                (Decode.field "title" Decode.string)
                                (Decode.maybe (Decode.field "description" Decode.string))

                        "glossary" ->
                            Decode.map2 GlossaryMetadata
                                (Decode.field "title" Decode.string)
                                (Decode.field "description" Decode.string)
                                |> Decode.map Glossary

                        "article" ->
                            Decode.map Article articleDecoder

                        "learn" ->
                            Decode.map Learn learnDecoder

                        _ ->
                            Decode.fail "Unhandled page type"
                )
        ]

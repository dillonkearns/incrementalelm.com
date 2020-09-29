module Metadata exposing (ArticleMetadata, GlossaryMetadata, LearnMetadata, Metadata(..), TipMetadata, decoder)

import Date exposing (Date)
import Dict exposing (Dict)
import Element exposing (Element)
import Element.Font as Font
import Iso8601
import Json.Decode as Decode exposing (Decoder)
import List.Extra
import Pages
import Pages.ImagePath
import Time


type Metadata msg
    = Page { title : String, description : Maybe String, image : Maybe (Pages.ImagePath.ImagePath Pages.PathKey) }
    | Article (ArticleMetadata msg)
    | Learn LearnMetadata
    | Glossary GlossaryMetadata
    | Tip TipMetadata


type alias LearnMetadata =
    { title : String }


type alias GlossaryMetadata =
    { title : String, description : String }


type alias TipMetadata =
    { title : String
    , description : String
    , publishedAt : Date
    }


type alias ArticleMetadata msg =
    { title : { styled : List (Element msg), raw : String }
    , description : { styled : List (Element msg), raw : String }
    , coverImage : Pages.ImagePath.ImagePath Pages.PathKey
    }


articleDecoder : Decoder (ArticleMetadata msg)
articleDecoder =
    Decode.map3 ArticleMetadata
        (Decode.field "title" markdownString)
        (Decode.field "description" markdownString)
        (Decode.field "src" imageDecoder)


imageDecoder : Decoder (Pages.ImagePath.ImagePath Pages.PathKey)
imageDecoder =
    (Decode.string |> Decode.map (\src -> "images/" ++ src))
        |> Decode.andThen findImage


findImage : String -> Decoder (Pages.ImagePath.ImagePath Pages.PathKey)
findImage imagePath =
    case Pages.allImages |> List.Extra.find (\image -> Pages.ImagePath.toString image == imagePath) of
        Just image ->
            Decode.succeed image

        Nothing ->
            Decode.fail <|
                "Couldn't find image. Found \n"
                    ++ (List.map Pages.ImagePath.toString Pages.allImages |> String.join "\n")


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
                            Decode.map3 (\title description image -> Page { title = title, description = description, image = image })
                                (Decode.field "title" Decode.string)
                                (Decode.maybe (Decode.field "description" Decode.string))
                                (Decode.maybe (Decode.field "image" imageDecoder))

                        "glossary" ->
                            Decode.map2 GlossaryMetadata
                                (Decode.field "title" Decode.string)
                                (Decode.field "description" Decode.string)
                                |> Decode.map Glossary

                        "article" ->
                            Decode.map Article articleDecoder

                        "tip" ->
                            Decode.map3 TipMetadata
                                (Decode.field "title" Decode.string)
                                (Decode.field "description" Decode.string)
                                (Decode.field "publishAt"
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
                                |> Decode.map Tip

                        "learn" ->
                            Decode.map Learn learnDecoder

                        _ ->
                            Decode.fail "Unhandled page type"
                )
        ]

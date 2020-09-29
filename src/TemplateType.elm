module TemplateType exposing (..)

import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder)


type TemplateType
    = Page { title : String, description : Maybe String }
    | Article ArticleMetadata
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


type alias ArticleMetadata =
    { title : String
    , description : String
    , coverImage : String
    }


articleDecoder : Decoder ArticleMetadata
articleDecoder =
    Decode.map3 ArticleMetadata
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "src"
            (Decode.string |> Decode.map (\src -> "/images/" ++ src))
        )


learnDecoder : Decoder LearnMetadata
learnDecoder =
    Decode.map LearnMetadata
        (Decode.field "title" Decode.string)


decoder : Decoder TemplateType
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

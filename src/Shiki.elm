module Shiki exposing (Highlighted, ShikiToken, decoder, view)

import Html exposing (Html)
import Html.Attributes as Attr exposing (class)
import Json.Decode as Decode exposing (Decoder)


type alias ShikiToken =
    { content : String
    , color : Maybe String
    , fontStyle : Maybe ( String, String )
    }


type alias Highlighted =
    { lines : List (List ShikiToken)
    , fg : String
    , bg : String
    }


decoder : Decoder Highlighted
decoder =
    Decode.map3 Highlighted
        (Decode.field "tokens" (Decode.list (Decode.list shikiTokenDecoder)))
        (Decode.field "fg" Decode.string)
        (Decode.field "bg" Decode.string)


shikiTokenDecoder : Decoder ShikiToken
shikiTokenDecoder =
    Decode.map3 ShikiToken
        (Decode.field "content" Decode.string)
        (Decode.maybe (Decode.field "color" Decode.string))
        (Decode.maybe (Decode.field "fontStyle" fontStyleDecoder) |> Decode.map (Maybe.andThen identity))


fontStyleDecoder : Decoder (Maybe ( String, String ))
fontStyleDecoder =
    Decode.int
        |> Decode.map
            (\styleNumber ->
                case styleNumber of
                    1 ->
                        Just ( "font-style", "italic" )

                    2 ->
                        Just ( "font-style", "bold" )

                    4 ->
                        Just ( "font-style", "underline" )

                    _ ->
                        Nothing
            )


view : List (Html.Attribute msg) -> Highlighted -> Html msg
view attrs highlighted =
    highlighted.lines
        |> List.indexedMap
            (\lineIndex line ->
                let
                    isLastLine : Bool
                    isLastLine =
                        List.length highlighted.lines == (lineIndex + 1)
                in
                Html.span [ class "line" ]
                    ((line
                        |> List.map
                            (\token ->
                                Html.span
                                    [ Attr.style "color" (token.color |> Maybe.withDefault highlighted.fg)
                                    , token.fontStyle
                                        |> Maybe.map
                                            (\( key, value ) ->
                                                Attr.style key value
                                            )
                                        |> Maybe.withDefault (Attr.title "")
                                    ]
                                    [ Html.text token.content ]
                            )
                     )
                        ++ [ if isLastLine then
                                Html.text ""

                             else
                                Html.text "\n"
                           ]
                    )
            )
        |> Html.code []
        |> List.singleton
        |> Html.pre
            ([ Attr.style "background-color" highlighted.bg
             , Attr.style "white-space" "pre-wrap"
             , Attr.style "overflow-wrap" "break-word"
             ]
                ++ attrs
            )

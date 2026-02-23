module TwitchButton exposing (IsOnAir, notOnAir, request, viewIfOnAir)

import Html exposing (Html)
import Html.Attributes as Attr
import Http
import Json.Decode as Decode
import Tailwind as Tw exposing (classes)
import Tailwind.Theme exposing (background, s2)


viewIfOnAir : IsOnAir -> Html msg -> Html msg
viewIfOnAir isOnAir ifNotOnAirView =
    case isOnAir of
        OnAir ->
            view

        NotOnAir ->
            ifNotOnAirView


view : Html msg
view =
    Html.a
        [ Attr.href "https://twitch.tv/dillonkearns"
        , Attr.class "on-air"
        , classes
            [ Tw.raw "bg-[rgb(200,20,20)]"
            , Tw.raw "hover:bg-[rgb(180,10,10)]"
            , Tw.text_simple background
            , Tw.rounded
            , Tw.p s2
            , Tw.raw "font-bold"
            ]
        ]
        [ Html.text "On Air"
        ]


type IsOnAir
    = OnAir
    | NotOnAir


notOnAir : IsOnAir
notOnAir =
    NotOnAir


request : Cmd (Result Http.Error IsOnAir)
request =
    Http.request
        { url = "https://api.twitch.tv/helix/streams?first=20&user_login=dillonkearns"
        , method = "GET"
        , headers = [ Http.header "Client-ID" "acn45g80vbppbxzixgvikgew2nzemo" ]
        , body = Http.emptyBody
        , expect = Http.expectJson identity isLiveDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


isLiveDecoder : Decode.Decoder IsOnAir
isLiveDecoder =
    Decode.field "data"
        (Decode.list
            (Decode.field "type" Decode.string)
        )
        |> Decode.map
            (\entries ->
                if (entries |> List.filter (\typeString -> typeString == "live") |> List.length) > 0 then
                    OnAir

                else
                    NotOnAir
            )

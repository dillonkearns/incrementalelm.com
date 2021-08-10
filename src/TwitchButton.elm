module TwitchButton exposing (IsOnAir, notOnAir, request, viewIfOnAir)

import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr exposing (css)
import Http
import Json.Decode as Decode
import Tailwind.Utilities as Tw


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
        , css
            [ Css.backgroundColor (Css.rgb 200 20 20)
            , Css.hover [ Css.backgroundColor (Css.rgb 180 10 10) ]
            , Tw.text_background
            , Tw.rounded
            , Tw.p_2
            , Tw.font_bold
            ]
        ]
        [ --View.FontAwesome.icon "fas fa-broadcast-tower" |> Element.el [],
          Html.text "On Air"
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
        , headers = [ Http.header "Client-ID" "acn45g80vbppbxzixgvikgew2nzemo" ] --
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

module TwitchButton exposing (IsOnAir, notOnAir, request, viewIfOnAir)

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font
import Html.Attributes as Attr
import Http
import Json.Decode as Decode
import Style exposing (palette)
import View.FontAwesome


viewIfOnAir : IsOnAir -> Element.Element msg -> Element.Element msg
viewIfOnAir isOnAir ifNotOnAirView =
    case isOnAir of
        OnAir ->
            view

        NotOnAir ->
            ifNotOnAirView


view : Element.Element msg
view =
    Element.newTabLink []
        { url = "https://twitch.tv/dillonkearns"
        , label =
            Element.row
                [ Element.spacing 5
                , Element.Font.color palette.mainBackground
                , Element.htmlAttribute (Attr.class "on-air")
                , Element.mouseOver
                    [ Background.color (Element.rgba255 200 20 20 1)
                    ]
                , Background.color (Element.rgba255 200 20 20 1)
                , Element.padding 15
                , Border.rounded 10
                , Style.fontSize.body
                ]
                [ View.FontAwesome.icon "fas fa-broadcast-tower" |> Element.el [], Element.text "On Air" ]
        }


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

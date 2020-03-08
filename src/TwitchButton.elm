module TwitchButton exposing (..)

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font
import Html.Attributes
import Style exposing (palette)
import View.FontAwesome


view =
    Element.link []
        { url = "/tips"
        , label =
            Element.row
                [ Element.spacing 5
                , Element.Font.color palette.mainBackground
                , Element.htmlAttribute (Html.Attributes.class "on-air")
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

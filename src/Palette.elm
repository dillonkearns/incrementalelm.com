module Palette exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


textQuote : String -> Element msg
textQuote string =
    blockQuote
        [ paragraph
            [ Element.spacing 15
            , Font.size 20
            ]
            [ text string ]
        ]


blockQuote : List (Element msg) -> Element msg
blockQuote children =
    column
        [ Border.widthEach { top = 0, right = 0, bottom = 0, left = 10 }
        , Element.padding 10
        , Border.color (Element.rgb255 145 145 145)
        , Background.color (Element.rgb255 245 245 245)
        ]
        children

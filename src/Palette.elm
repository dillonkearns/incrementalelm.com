module Palette exposing (blockQuote, textQuote)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


textQuote : String -> Element msg
textQuote string =
    blockQuote
        [ paragraph
            [ spacing 15
            , Font.size 20
            ]
            [ text string ]
        ]


blockQuote : List (Element msg) -> Element msg
blockQuote children =
    column
        [ Border.widthEach { top = 0, right = 0, bottom = 0, left = 10 }
        , padding 10
        , Border.color (rgb255 145 145 145)
        , Background.color (rgb255 245 245 245)
        ]
        children

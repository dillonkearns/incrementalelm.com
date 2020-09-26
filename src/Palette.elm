module Palette exposing (..)

import Element exposing (column)
import Element.Background as Background
import Element.Border as Border


blockQuote : List (Element.Element msg) -> Element.Element msg
blockQuote children =
    column
        [ Border.widthEach { top = 0, right = 0, bottom = 0, left = 10 }
        , Element.padding 10
        , Border.color (Element.rgb255 145 145 145)
        , Background.color (Element.rgb255 245 245 245)
        ]
        children

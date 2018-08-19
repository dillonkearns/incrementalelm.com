module Style exposing (..)

import Animation
import Element
import Element.Font


fonts =
    { title = Element.Font.family [ Element.Font.typeface "Open Sans" ]
    , body = Element.Font.family [ Element.Font.typeface "Raleway" ]
    }


palette =
    { main = elementRgb 216 219 226
    , bold = elementRgb 0 23 31
    , light = elementRgb 0 126 167
    , highlight = elementRgb 0 168 232
    , mainBackground = elementRgb 255 255 255
    , highlightBackground = elementRgb 0 52 89
    }


elementRgb red green blue =
    Element.rgb (red / 255) (green / 255) (blue / 255)


rgb : Int -> Int -> Int -> Animation.Color
rgb red green blue =
    { red = red
    , green = green
    , blue = blue
    , alpha = 1.0
    }


animationPalette =
    { main = rgb 216 219 226
    , bold = rgb 0 23 31
    , light = rgb 0 126 167
    , highlight = rgb 0 168 232
    , mainBackground = rgb 255 255 255
    , highlightBackground = rgb 0 52 89
    }

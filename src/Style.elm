module Style exposing (..)

import Animation
import Element



-- type alias Palette =
--     { main : Color
--     , bold : Color
--     , light : Color
--     , highlight : Color
--     , mainBackground : Color
--     , highlightBackground : Color
--     }
--
--
-- palette : Palette


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



{-
   Element.rgb 255 255 255
   Element.rgb 0 23 31
   Element.rgb 0 52 89
   Element.rgb 0 126 167
   Element.rgb 0 168 232
-}
-- originalPalette : Palette
-- originalPalette =
--     { main = Element.rgb 216 219 226
--     , bold = Element.rgb 27 27 30
--     , light = Element.rgb 169 188 208
--     , highlight = Element.rgb 88 164 176
--     , mainBackground = Color.white
--     , highlightBackground = Element.rgb 88 164 176
--     }
-- palette3 : Palette
-- palette3 =
--     { main = Element.rgb 216 219 226
--     , bold = Element.rgb 27 27 30
--     , light = Element.rgb 169 188 208
--     , highlight = Element.rgb 88 164 176
--     , mainBackground = Color.white
--     , highlightBackground = Element.rgb 55 63 81
--     }
-- paletteLightGreen : Palette
-- paletteLightGreen =
--     { main = Element.rgb 66 122 161
--     , bold = Element.rgb 5 102 141
--     , light = Element.rgb 169 188 208
--     , highlight = Element.rgb 165 190 0
--     , mainBackground = Element.rgb 235 242 250
--     , highlightBackground = Element.rgb 103 148 54
--     }
-- type alias Palette =
--     { orange : Color.Color
--     , green : Color.Color
--     , lavender : Color.Color
--     , blue : Color.Color
--     }
--
--
-- palette : Palette
-- palette =
--     { orange = rgb 216 219 226
--     , green = rgb 27 27 30
--     , lavender = rgb 169 188 208
--     , blue = rgb 88 164 176
--     }
--
--
-- purplePalette : Palette
-- purplePalette =
--     { orange = rgb 86 3 173
--     , green = Element.rgb 21 26 29
--     , lavender = rgb 216 219 226
--     , blue = rgb 67 72 76
--     }
--
--
-- originalPalette : Palette
-- originalPalette =
--     { orange = rgb 240 173 0
--     , green = rgb 127 209 59
--     , lavender = rgb 90 99 120
--     , blue = rgb 96 181 204
--     }

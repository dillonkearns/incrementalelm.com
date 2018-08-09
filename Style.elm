module Style exposing (..)

import Color exposing (Color)


type alias Palette =
    { main : Color
    , bold : Color
    , light : Color
    , highlight : Color
    , mainBackground : Color
    , highlightBackground : Color
    }


palette : Palette
palette =
    { main = Color.rgb 216 219 226
    , bold = Color.rgb 27 27 30
    , light = Color.rgb 169 188 208
    , highlight = Color.rgb 88 164 176
    , mainBackground = Color.white
    , highlightBackground = Color.rgb 55 63 81
    }



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
--     , green = Color.rgb 21 26 29
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

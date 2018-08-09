module ElmLogo exposing (polygons)

import Animation exposing (px)
import Color exposing (blue, darkBlue, green, purple, rgb)


type alias Palette =
    { orange : Color.Color
    , green : Color.Color
    , lavender : Color.Color
    , blue : Color.Color
    }


palette : Palette
palette =
    { orange = rgb 216 219 226
    , green = rgb 27 27 30
    , lavender = rgb 55 63 81
    , blue = rgb 88 164 176
    }


originalPalette : Palette
originalPalette =
    { orange = rgb 240 173 0
    , green = rgb 127 209 59
    , lavender = rgb 90 99 120
    , blue = rgb 96 181 204
    }


polygons : List (List Animation.Property)
polygons =
    [ [ Animation.points
            [ ( 168, 163.5 ) -- West
            , ( 245.298, 240.432 ) -- South
            , ( 323.298, 160.375 ) -- East
            , ( 245.213, 83.375 ) -- North
            ]
      , Animation.fill palette.green
      ]
    , [ Animation.points
            [ ( 161.649, 152.782 )
            , ( 231.514, 82.916 )
            , ( 91.783, 82.916 )
            ]
      , Animation.fill palette.orange
      ]
    , [ Animation.points
            [ ( 8.867, 0 )
            , ( 79.241, 70.375 )
            , ( 232.213, 70.375 )
            , ( 161.838, 0 )
            ]
      , Animation.fill palette.green
      ]
    , [ Animation.points
            [ ( 323.298, 143.724 )
            , ( 323.298, 0 )
            , ( 179.573, 0 )
            ]
      , Animation.fill palette.blue
      ]
    , [ Animation.points
            [ ( 152.781, 161.649 )
            , ( 0, 8.868 )
            , ( 0, 314.432 )
            ]
      , Animation.fill palette.lavender
      ]
    , [ Animation.points
            [ ( 255.522, 246.655 )
            , ( 323.298, 314.432 )
            , ( 323.298, 178.879 )
            ]
      , Animation.fill palette.orange
      ]
    , [ Animation.points
            [ ( 161.649, 170.517 )
            , ( 8.869, 323.298 )
            , ( 314.43, 323.298 )
            ]
      , Animation.fill palette.blue
      ]
    ]



-- 0.7071 0.7071 -0.7071 0.7071 186.4727 -127.2386

module ElmLogo exposing (polygons)

import Animation
import Style exposing (animationPalette)


polygons : List (List Animation.Property)
polygons =
    [ [ Animation.points
            [ ( 168, 163.5 ) -- West
            , ( 245.298, 240.432 ) -- South
            , ( 323.298, 160.375 ) -- East
            , ( 245.213, 83.375 ) -- North
            ]
      , Animation.fill animationPalette.bold
      ]
    , [ Animation.points
            [ ( 161.649, 152.782 )
            , ( 231.514, 82.916 )
            , ( 91.783, 82.916 )
            ]
      , Animation.fill animationPalette.main
      ]
    , [ Animation.points
            [ ( 8.867, 0 )
            , ( 79.241, 70.375 )
            , ( 232.213, 70.375 )
            , ( 161.838, 0 )
            ]
      , Animation.fill animationPalette.bold
      ]
    , [ Animation.points
            [ ( 323.298, 143.724 )
            , ( 323.298, 0 )
            , ( 179.573, 0 )
            ]
      , Animation.fill animationPalette.highlight
      ]
    , [ Animation.points
            [ ( 152.781, 161.649 )
            , ( 0, 8.868 )
            , ( 0, 314.432 )
            ]
      , Animation.fill animationPalette.light
      ]
    , [ Animation.points
            [ ( 255.522, 246.655 )
            , ( 323.298, 314.432 )
            , ( 323.298, 178.879 )
            ]
      , Animation.fill animationPalette.main
      ]
    , [ Animation.points
            [ ( 161.649, 170.517 )
            , ( 8.869, 323.298 )
            , ( 314.43, 323.298 )
            ]
      , Animation.fill animationPalette.highlight
      ]
    ]



-- 0.7071 0.7071 -0.7071 0.7071 186.4727 -127.2386

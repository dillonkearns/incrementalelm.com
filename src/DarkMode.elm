module DarkMode exposing (DarkMode(..), darkModeDecoder, view)

import Html
import Html.Events
import Json.Decode
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr
import Tailwind as Tw exposing (batch)
import Tailwind.Theme exposing (s6)


darkModeDecoder : Json.Decode.Decoder DarkMode
darkModeDecoder =
    Json.Decode.string
        |> Json.Decode.map
            (\value ->
                if value == "dark" then
                    Dark

                else
                    Light
            )


type DarkMode
    = Dark
    | Light


view attrs onClick =
    Html.button
        (Html.Events.onClick onClick :: attrs)
        [ sunIcon
        , moonIcon
        ]


moonIcon =
    svg
        [ SvgAttr.class ("dark-only " ++ Tw.toClass (batch [ Tw.h s6, Tw.w s6 ]))
        , SvgAttr.fill "none"
        , SvgAttr.viewBox "0 0 24 24"
        , SvgAttr.stroke "currentColor"
        ]
        [ path
            [ SvgAttr.strokeLinecap "round"
            , SvgAttr.strokeLinejoin "round"
            , SvgAttr.strokeWidth "2"
            , SvgAttr.d "M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"
            ]
            []
        ]


sunIcon =
    svg
        [ SvgAttr.class ("light-only " ++ Tw.toClass (batch [ Tw.h s6, Tw.w s6 ]))
        , SvgAttr.fill "none"
        , SvgAttr.viewBox "0 0 24 24"
        , SvgAttr.stroke "currentColor"
        ]
        [ path
            [ SvgAttr.strokeLinecap "round"
            , SvgAttr.strokeLinejoin "round"
            , SvgAttr.strokeWidth "2"
            , SvgAttr.d "M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"
            ]
            []
        ]

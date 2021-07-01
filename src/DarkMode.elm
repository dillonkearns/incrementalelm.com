module DarkMode exposing (DarkMode(..), dark, darkModeDecoder, view)

import Css
import Css.Global
import Html.Styled
import Html.Styled.Events
import Json.Decode
import Svg.Styled exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Utilities as Tw


dark : DarkMode -> List Css.Style -> Css.Style
dark darkMode attrs =
    case darkMode of
        Dark ->
            Css.batch attrs

        Light ->
            Css.batch []


darkModeDecoder : Json.Decode.Decoder DarkMode
darkModeDecoder =
    Json.Decode.bool
        |> Json.Decode.map
            (\isDark ->
                if isDark then
                    Dark

                else
                    Light
            )


type DarkMode
    = Dark
    | Light


view attrs onClick =
    Html.Styled.button
        (Html.Styled.Events.onClick onClick :: attrs)
        [ sunIcon
        , moonIcon
        ]



--case darkMode of
--    Light ->
--        sunIcon
--
--    Dark ->
--        moonIcon


moonIcon =
    svg
        [ SvgAttr.css
            [ Tw.h_6
            , Tw.w_6
            ]
        , SvgAttr.fill "none"
        , SvgAttr.viewBox "0 0 24 24"
        , SvgAttr.stroke "currentColor"
        , SvgAttr.class "light-only"
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
        [ SvgAttr.css
            [ Tw.h_6
            , Tw.w_6
            ]
        , SvgAttr.class "dark-only"
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

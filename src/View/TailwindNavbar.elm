module View.TailwindNavbar exposing (view)

import Css
import DarkMode exposing (DarkMode)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import Link
import Path exposing (Path)
import Route exposing (Route)
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw


view : DarkMode -> msg -> msg -> Path -> Html msg
view darkMode toggleDarkMode toggleMobileMenuMsg currentPath =
    nav
        [ css
            [ Tw.flex
            , Tw.items_center

            --, Tw.bg_white
            , Tw.z_20
            , Tw.fixed
            , Tw.top_0
            , Tw.left_0
            , Tw.right_0
            , Tw.h_16
            , Tw.border_b
            , Tw.border_gray_200
            , Tw.px_6
            , Tw.shadow
            , Tw.bg_background
            , Tw.border_gray_900
            , Tw.text_foreground

            --, Bp.dark
            --    [ Tw.bg_dark
            --    , Tw.border_gray_900
            --    ]
            ]
        ]
        [ div
            [ css
                [ Tw.hidden
                , Tw.w_full
                , Tw.flex
                , Tw.items_center
                , Bp.md
                    [ Tw.block
                    ]
                ]
            ]
            [ a
                [ css
                    [ Tw.no_underline
                    , Tw.text_current
                    , Tw.flex
                    , Tw.items_center
                    , Css.hover
                        [ Tw.opacity_75
                        ]
                    ]
                , Attr.href "/"
                ]
                [ span
                    [ css
                        [ Tw.mr_0
                        , Tw.neg_ml_2
                        , Tw.font_extrabold
                        , Tw.inline

                        -- TODO try with https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/Css#pseudoClass
                        , Bp.md
                            [ Tw.inline
                            ]
                        , Css.fontFamilies [ "Raleway" ]
                        ]
                    ]
                    [ text "Incremental Elm" ]
                ]
            ]
        , headerLink currentPath Route.Notes "Notes"
        , headerLink currentPath Route.Live "Live Streams"
        , headerLink currentPath (Route.Page_ { page = "services" }) "Services"
        , DarkMode.view
            [ css
                [ Tw.ml_2
                ]
            ]
            toggleDarkMode
        ]


headerLink : Path -> Route -> String -> Html msg
headerLink currentPagePath linkTo name =
    linkTo
        |> Link.htmlLink
            [ css [ Css.fontFamilies [ "Raleway" ] ]
            ]
            (linkInner currentPagePath linkTo name)


linkInner : Path -> Route -> String -> Html msg
linkInner currentPagePath linkTo name =
    let
        isCurrentPath : Bool
        isCurrentPath =
            List.head (Path.toSegments currentPagePath) == (linkTo |> Route.toPath |> Path.toSegments |> List.head)
    in
    span
        [ css
            [ Tw.text_sm
            , Tw.p_2
            , Tw.whitespace_nowrap
            , if isCurrentPath then
                Css.batch
                    [ Tw.text_blue_600
                    , Css.hover
                        [ Tw.text_blue_700
                        ]
                    ]

              else
                Css.batch
                    [ --Tw.text_gray_600
                      Tw.text_foreground

                    --, DarkMode.dark darkMode
                    --    [ Tw.bg_black
                    --    , Tw.border_gray_900
                    --    , Tw.text_white
                    --    ]
                    , Css.hover
                        [ Tw.text_gray_900
                        ]
                    ]
            ]
        ]
        [ text name ]

module View.TailwindNavbar exposing (view)

import DarkMode exposing (DarkMode)
import Html exposing (..)
import Html.Attributes as Attr
import Link
import Route exposing (Route)
import Tailwind as Tw exposing (batch, classes)
import Tailwind.Breakpoints exposing (md)
import Tailwind.Theme exposing (background, highlight, s0, s2, s4, s6, s8, s16)
import UrlPath exposing (UrlPath)
import User exposing (User)


view : Maybe User -> DarkMode -> msg -> msg -> UrlPath -> Html msg
view maybeUser darkMode toggleDarkMode toggleMobileMenuMsg currentPath =
    nav
        [ classes
            [ Tw.flex
            , Tw.items_center
            , Tw.z_20
            , Tw.fixed
            , Tw.raw "top-0"
            , Tw.raw "left-0"
            , Tw.raw "right-0"
            , Tw.h s16
            , Tw.border_b
            , Tw.raw "border-gray-200"
            , Tw.px s6
            , Tw.shadow
            , Tw.bg_simple background
            , Tw.raw "border-gray-900"
            , Tw.raw "text-foreground"
            ]
        ]
        [ div
            [ classes
                [ Tw.hidden
                , Tw.w_full
                , Tw.flex
                , Tw.items_center
                , md
                    [ Tw.block
                    ]
                ]
            ]
            [ a
                [ classes
                    [ Tw.no_underline
                    , Tw.raw "text-current"
                    , Tw.flex
                    , Tw.items_center
                    , Tw.raw "hover:opacity-75"
                    ]
                , Attr.href "/"
                ]
                [ span
                    [ classes
                        [ Tw.mr s0
                        , Tw.raw "-ml-2"
                        , Tw.raw "font-extrabold"
                        , Tw.inline
                        , md
                            [ Tw.inline
                            ]
                        , Tw.raw "font-raleway"
                        ]
                    ]
                    [ text "Incremental Elm" ]
                ]
            ]
        , headerLink currentPath Route.Notes "Notes"
        , headerLink currentPath Route.Live "Live Streams"
        , headerLink currentPath Route.Courses "Courses"
        , DarkMode.view
            [ classes
                [ Tw.ml s2
                ]
            ]
            toggleDarkMode
        , maybeUser
            |> Maybe.map userBadge
            |> Maybe.withDefault (text "")
        ]


userBadge : User -> Html msg
userBadge user =
    img
        [ Attr.src user.avatarUrl
        , classes
            [ Tw.h s8
            , Tw.ml s4
            ]
        ]
        []


headerLink : UrlPath -> Route -> String -> Html msg
headerLink currentPagePath linkTo name =
    linkTo
        |> Link.htmlLink
            [ classes
                [ Tw.raw "font-raleway"
                ]
            ]
            (linkInner currentPagePath linkTo name)


linkInner : UrlPath -> Route -> String -> Html msg
linkInner currentPagePath linkTo name =
    let
        isCurrentPath : Bool
        isCurrentPath =
            List.head currentPagePath == List.head (Route.toPath linkTo)
    in
    span
        [ classes
            [ Tw.raw "text-sm"
            , Tw.raw "font-bold"
            , Tw.p s2
            , Tw.whitespace_nowrap
            , if isCurrentPath then
                batch
                    [ Tw.text_simple highlight
                    , Tw.raw "hover:underline"
                    ]

              else
                batch
                    [ Tw.raw "text-foreground"
                    , Tw.raw "hover:text-highlight"
                    , Tw.raw "hover:underline"
                    ]
            ]
        ]
        [ text name ]

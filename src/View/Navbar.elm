module View.Navbar exposing (view)

import Animation exposing (backgroundColor)
import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation
import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import ElmLogo
import Html exposing (Html)
import Page.Home
import Style exposing (fontSize, fonts, palette)
import Task
import Time
import Url exposing (Url)
import Url.Builder


view model animationView =
    Element.link []
        { label =
            Element.row
                [ Background.color palette.mainBackground
                , Element.alignTop
                ]
                [ animationView model
                , logoText
                ]
        , url = "/"
        }


isMobile { dimensions } =
    dimensions.width < 1000


logoText =
    [ Element.text "Incremental Elm"
        |> Element.el
            [ Element.Font.color palette.bold
            , fontSize.logo
            ]
    , Element.text "Consulting"
        |> Element.el
            [ Element.Font.color palette.bold
            , fontSize.small
            , Element.alignRight
            ]
    ]
        |> Element.column
            [ fonts.title
            , Element.width Element.shrink
            , Element.height Element.shrink
            , Element.spacing 5
            ]

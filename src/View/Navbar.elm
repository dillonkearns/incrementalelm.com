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
import Style exposing (fonts, palette)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Time
import Url exposing (Url)
import Url.Builder


view model animationView =
    -- if isMobile model then
    --     Element.column
    --         [ Background.color palette.mainBackground
    --         , Element.alignTop
    --         , Element.centerX
    --         , Element.padding 25
    --         ]
    --         [ animationView model
    --         , logoText
    --         ]
    --
    -- else
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
            , Element.Font.size 50
            ]
    , Element.text "Consulting"
        |> Element.el
            [ Element.Font.color palette.bold
            , Element.Font.size 17
            , Element.alignRight
            ]
    ]
        |> Element.column
            [ fonts.title
            , Element.width Element.shrink
            , Element.height Element.shrink
            , Element.spacing 5
            ]

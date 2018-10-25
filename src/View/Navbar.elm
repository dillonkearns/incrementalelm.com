module View.Navbar exposing (modalMenuView, view)

import Animation exposing (backgroundColor)
import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font
import ElmLogo
import Html exposing (Html)
import Page.Home
import Style exposing (fontSize, fonts, palette)
import Task
import Time
import Url exposing (Url)
import Url.Builder
import View.FontAwesome
import View.MenuBar


view model animationView startAnimationMsg =
    Element.row
        [ Element.spaceEvenly
        , Element.width Element.fill
        , Border.shadow { offset = ( 1, 1 ), size = 1, blur = 5, color = Element.rgba255 0 0 0 0.3 }
        ]
        [ logoView model animationView
        , links model startAnimationMsg
        ]


links model startAnimationMsg =
    Element.row
        [ Element.spacing 20
        , Element.padding 20
        , fonts.body
        , Element.Font.color palette.bold
        ]
        (if isMobile model then
            [ View.MenuBar.view model startAnimationMsg ]

         else
            [ Element.text "Learn Elm"
            , Element.link [] { label = Element.text "Coaches", url = "/coaches" }
            , Element.text "Articles"
            , Element.text "Contact"
            ]
        )


modalMenuView menuAnimation =
    Element.column
        ([ Background.color palette.main
         , Element.height Element.fill
         , Element.width Element.fill
         , Element.padding 80
         ]
            ++ (menuAnimation
                    |> Animation.render
                    |> List.map Element.htmlAttribute
               )
        )
        [ Element.column
            [ Element.centerX
            , Element.width Element.shrink
            , Element.spacing 25
            , fonts.body
            , Style.fontSize.title
            , Element.Font.color palette.bold
            ]
            [ Element.text "Learn Elm"
            , Element.text "Coaches"
            , Element.text "Articles"
            , Element.text "Contact"
            ]
        ]


logoView model animationView =
    Element.link
        []
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

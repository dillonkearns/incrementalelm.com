module View.Navbar exposing (modalMenuView, view)

import Animation exposing (backgroundColor)
import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation
import Dimensions
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font
import ElmLogo
import Html exposing (Html)
import Route
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
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
        , linksView model startAnimationMsg
        ]


links =
    [ { name = "Articles", route = Route.Article Nothing }
    , { name = "Services", route = Route.Learn Nothing }
    ]


linksView model startAnimationMsg =
    Element.row
        [ Element.spacing 20
        , Element.padding 20
        , fonts.body
        , Element.Font.color palette.bold
        ]
        (if Dimensions.isMobile model.dimensions then
            [ View.MenuBar.view model startAnimationMsg ]

         else
            (links
                |> List.map linkView
            )
                ++ [ contactButton ]
        )


contactButton =
    Element.link
        [ Element.centerX
        ]
        { url = "/tips"
        , label =
            Style.Helpers.button
                { fontColor = .mainBackground
                , backgroundColor = .highlight
                , size = fontSize.body
                }
                [ Element.text "Get Weekly elm Tips" ]
        }


linkView link =
    Element.link [ Element.width Element.fill ]
        { label = Element.text link.name
        , url = Route.toUrl link.route
        }


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
            , Element.Font.center
            , Element.width Element.shrink
            , Element.spacing 25
            , fonts.body
            , Style.fontSize.title
            , Element.Font.color palette.bold
            ]
            ((links |> List.map linkView) ++ [ contactButton ])
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


logoText =
    [ Element.text "Incremental Elm"
        |> Element.el
            [ Element.Font.color palette.bold
            , fontSize.logo
            ]
    , Element.text "Training"
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

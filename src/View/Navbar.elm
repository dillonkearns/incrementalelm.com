module View.Navbar exposing (modalMenuView, view)

import Animation
import Dimensions
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font
import Link
import Route exposing (Route)
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
import View.MenuBar


view :
    { a | dimensions : Dimensions.Dimensions, menuBarAnimation : View.MenuBar.Model }
    -> ({ a | dimensions : Dimensions.Dimensions, menuBarAnimation : View.MenuBar.Model } -> Element c)
    -> c
    -> Element c
view model animationView startAnimationMsg =
    Element.row
        [ Element.spaceEvenly
        , Element.width Element.fill
        , Border.shadow { offset = ( 1, 1 ), size = 1, blur = 5, color = Element.rgba255 0 0 0 0.3 }
        ]
        [ logoView model animationView
        , linksView model startAnimationMsg
        ]


links : List { name : String, url : Route }
links =
    [ { name = "Notes", url = Route.Notes }
    , { name = "Live Streams", url = Route.Live }
    , { name = "Services", url = Route.Page_ { page = "services" } }
    ]


linksView : { a | dimensions : Dimensions.Dimensions, menuBarAnimation : View.MenuBar.Model } -> msg -> Element msg
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


contactButton : Element msg
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
                [ Element.text "Elm Tips" ]
        }


linkView : { url : Route, name : String } -> Element msg
linkView link =
    Link.link link.url
        [ Element.width Element.fill ]
        (Element.text link.name)


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
            , fontSize.title
            , Element.Font.color palette.bold
            ]
            ((links |> List.map linkView) ++ [ contactButton ])
        ]


logoView : a -> (a -> Element msg) -> Element msg
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


logoText : Element msg
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

module Page.Coaches exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
import View.FontAwesome


view :
    { width : Float
    , height : Float
    , device : Element.Device
    }
    -> Element.Element msg
view dimensions =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.padding
            (if dimensions.width <= 1000 then
                20

             else
                50
            )
        , Element.spacing 30
        ]
        [ [ Element.text "Incremental Elm Coaches" ]
            |> Element.paragraph
                [ Style.fontSize.title
                , Style.fonts.title
                , Element.Font.center
                , Element.width Element.fill
                ]
        , aboutDillon dimensions
        ]


aboutDillon dimensions =
    if dimensions.width <= 1000 then
        Element.row
            [ Element.Border.shadow { offset = ( 2, 1 ), size = 1, blur = 4, color = Element.rgb 0.8 0.8 0.8 }
            , Element.width Element.fill
            , Element.padding 30
            ]
            [ Element.column
                [ Element.spacing 25
                , Element.centerX
                , Element.width Element.fill
                ]
                [ avatar
                , Element.paragraph
                    [ fontSize.title
                    , Element.Font.size 32
                    , Element.width Element.fill
                    , Element.Font.center
                    ]
                    [ Element.text "Dillon Kearns" ]
                , bioView
                , authorResources dimensions
                ]
            ]

    else
        Element.row
            [ Element.height (Element.shrink |> Element.minimum 200)
            , Element.Border.shadow { offset = ( 2, 1 ), size = 1, blur = 4, color = Element.rgb 0.8 0.8 0.8 }
            , Element.centerX
            , Element.width (Element.fill |> Element.maximum 1200)
            ]
            [ avatar
            , Element.el
                [ Element.width (Element.fill |> Element.maximum 1000)
                , Element.padding 30
                ]
                (Element.column
                    [ Element.spacing 25
                    , Element.centerX
                    ]
                    [ Element.paragraph
                        [ fontSize.title
                        , Element.Font.size 32
                        ]
                        [ Element.text "Dillon Kearns" ]
                    , bioView
                    , authorResources dimensions
                    ]
                )
            ]


authorResources dimensions =
    if dimensions.width > 1000 then
        Element.column [ Element.spacing 8, Element.width Element.fill ]
            [ Element.row
                [ Element.spaceEvenly
                , Element.width Element.fill
                , Element.spacing 10
                ]
                [ resource "elm-graphql" "https://github.com/dillonkearns/elm-graphql" Library
                , resource "elm-typescript-interop" "https://github.com/dillonkearns/elm-typescript-interop" Library
                ]
            , Element.row
                [ Element.spaceEvenly
                , Element.width Element.fill
                , Element.spacing 10
                ]
                [ resource "Developing for the Web with Extreme Safety" "https://www.youtube.com/watch?v=t-2GiOuLRZc" Video
                , resource "Mobster" "http://mobster.cc" App
                ]
            ]

    else
        Element.column [ Element.spacing 8, Element.centerX ]
            [ resource "elm-graphql" "https://github.com/dillonkearns/elm-graphql" Library
            , resource "elm-typescript-interop" "https://github.com/dillonkearns/elm-typescript-interop" Library
            , resource "Developing for the Web with Extreme Safety" "https://www.youtube.com/watch?v=t-2GiOuLRZc" Video
            , resource "Mobster" "http://mobster.cc" App
            ]


type Resource
    = Library
    | Video
    | App


resource resourceName url resourceType =
    let
        ( iconClasses, color, font ) =
            case resourceType of
                Library ->
                    ( "fa fa-code", palette.highlight, Style.fonts.code )

                Video ->
                    ( "fab fa-youtube", Element.rgb255 255 0 0, Style.fonts.title )

                App ->
                    ( "fas fa-desktop", Element.rgb255 0 122 255, Style.fonts.title )
    in
    Element.newTabLink [ Element.width Element.fill ]
        { label =
            Element.row [ Element.spacing 5 ]
                [ View.FontAwesome.styledIcon iconClasses [ Element.Font.color color ]
                , [ Element.text resourceName ] |> Element.paragraph [ font ]
                ]
        , url = url
        }


bioView =
    Element.paragraph
        [ Element.Font.size 16
        , Style.fonts.body
        , Element.width Element.fill
        ]
        [ Element.text dillonBio ]


avatar =
    Element.image [ Element.width (Element.fill |> Element.maximum 250), Element.centerX ]
        { src = "/assets/dillon2.jpg"
        , description = "Dillon Kearns"
        }


dillonBio =
    """As a consultant, Dillon introduced Elm at a Fortune 10 company and trained several teams to adopt it as their primary front-end framework. Dillon leverages his background in organizational change to help teams build learning cultures and continuously improve. His philosophy is that "if it's broken, your compiler should be the first to tell you." In his free time, he loves backpacking and playing the piano."""

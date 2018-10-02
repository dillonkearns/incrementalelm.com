module Page.Team exposing (view)

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
        [ Background.gradient
            { angle = -180
            , steps = [ Element.rgba255 0 52 89 0.7, Element.rgba255 0 126 167 0.7 ]
            }
        , Element.width Element.fill
        , Element.height Element.fill
        , Element.padding 30
        ]
        [ aboutDillon ]


aboutDillon =
    Element.row
        [ Element.height (Element.fill |> Element.maximum 300)
        , Element.spacing 30
        , Element.padding 50
        , Element.Border.shadow { offset = ( 2, 1 ), size = 1, blur = 4, color = Element.rgb 0.8 0.8 0.8 }
        , Background.color (Element.rgb255 255 255 255)
        , Element.centerX
        , Element.width (Element.fill |> Element.maximum 1200)
        ]
        [ avatar
        , Element.column [ Element.spacing 15, Element.width Element.fill ]
            [ name
            , Element.paragraph
                [ Element.width Element.fill
                , Element.Font.size 16
                , Style.fonts.body
                ]
                [ Element.text dillonBio ]
            ]
        ]


avatar =
    Element.image [ Element.height (Element.px 150) ]
        { src = "/assets/dillon.jpg"
        , description = "Dillon Kearns"
        }


name =
    Element.paragraph
        [ fontSize.title
        , Element.Font.size 32
        , Element.width Element.fill
        ]
        [ Element.text "Dillon Kearns" ]


dillonBio =
    "Dillon is an Agile Coach and Software Craftsman based out of Southern California. As an Agile Consultant, Dillon introduced Elm at a Fortune 10 company and trained several teams to help them adopt it as their primary front-end framework. He is a big proponent of emergent design, test-driven development, and continuous refactorings and hopes to help the community explore these techniques in the context of Elm. In his free time, he loves backpacking and playing the piano."

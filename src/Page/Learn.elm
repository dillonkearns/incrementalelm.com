module Page.Learn exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
import View.Ellie
import View.FontAwesome
import View.Resource as Resource


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
                30

             else
                200
            )
        , Element.spacing 30
        ]
        [ title "The Elm Architecture"
        , image
        , View.Ellie.view "3xfc59cYsd6a1"
        , resourcesView dimensions
            [ { name = "Architecture section of The Official Elm Guide"
              , url = "https://guide.elm-lang.org/architecture/"
              , kind = Resource.Article
              }
            , { name = "Add a -1 button to the Ellie example"
              , url = "https://ellie-app.com/3xfc59cYsd6a1"
              , kind = Resource.Exercise
              }
            ]
        ]


title text =
    [ Element.text text ]
        |> Element.paragraph
            [ Style.fontSize.title
            , Style.fonts.title
            , Element.Font.center
            , Element.width Element.fill
            ]


resourcesView dimensions resources =
    Element.column [ Element.spacing 32, Element.centerX ]
        [ title "Further Reading and Exercises"
        , Element.column [ Element.spacing 16, Element.centerX ]
            (resources |> List.map Resource.view)
        ]


image =
    Element.image [ Element.width (Element.fill |> Element.maximum 600), Element.centerX ]
        { src = "/assets/architecture.jpg"
        , description = "The Elm Architecture"
        }

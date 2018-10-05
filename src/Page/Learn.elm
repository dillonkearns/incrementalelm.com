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
        [ [ Element.text "The Elm Architecture" ]
            |> Element.paragraph
                [ Style.fontSize.title
                , Style.fonts.title
                , Element.Font.center
                , Element.width Element.fill
                ]
        , image
        , View.Ellie.view "3xfc59cYsd6a1"
        , authorResources dimensions
        ]


authorResources dimensions =
    Element.column [ Element.spacing 8, Element.centerX ]
        ([ { name = "Architecture section of The Official Elm Guide"
           , url = "https://guide.elm-lang.org/architecture/"
           , kind = Resource.Article
           }
         , { name = "Add a Decrement button to the Ellie example"
           , url = "https://ellie-app.com/3xfc59cYsd6a1"
           , kind = Resource.Exercise
           }
         ]
            |> List.map Resource.view
        )


image =
    Element.image [ Element.width (Element.fill |> Element.maximum 600), Element.centerX ]
        { src = "/assets/architecture.jpg"
        , description = "The Elm Architecture"
        }

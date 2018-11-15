module Page.Learn.Architecture exposing (details)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Font
import Page.Learn.Post exposing (Post)
import Style
import View.Ellie
import View.Resource as Resource


details : Dimensions -> Post msg
details dimensions =
    { pageName = "architecture"
    , title = "The Elm Architecture"
    , body =
        [ image
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
    }


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


title text =
    [ Element.text text ]
        |> Element.paragraph
            [ Style.fontSize.title
            , Style.fonts.title
            , Element.Font.center
            , Element.width Element.fill
            ]

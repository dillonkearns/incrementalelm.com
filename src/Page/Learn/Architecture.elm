module Page.Learn.Architecture exposing (details)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Font
import Mark
import Mark.Default
import MarkParser
import Page.Learn.Post exposing (Post)
import Style
import View.Ellie
import View.Resource as Resource


details : Post
details =
    { pageName = "architecture"
    , title = "The Elm Architecture"
    , body =
        """| Image
    src = /assets/architecture.jpg
    description = The Elm Architecture


| Ellie
    3xfc59cYsd6a1"""
    , resources =
        { title = Just "Further Reading and Exercises"
        , items =
            [ { name = "Architecture section of The Official Elm Guide"
              , url = "https://guide.elm-lang.org/architecture/"
              , kind = Resource.Article
              , description = Nothing
              }
            , { name = "Add a -1 button to the Ellie example"
              , url = "https://ellie-app.com/3xfc59cYsd6a1"
              , kind = Resource.Exercise
              , description = Nothing
              }
            ]
        }
    }

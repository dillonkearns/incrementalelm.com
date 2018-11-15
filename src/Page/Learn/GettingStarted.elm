module Page.Learn.GettingStarted exposing (details)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Font
import Page.Learn.Post exposing (Post)
import Style
import View.Ellie
import View.Resource as Resource


details : Post msg
details =
    { pageName = "getting-started"
    , title = "Getting Strated Resources"
    , body = body
    }


body dimensions =
    [ resourcesView dimensions
        [ { name = "The Official Elm Guide"
          , url = "https://guide.elm-lang.org/"
          , kind = Resource.Article
          }
        ]
    ]


resourcesView dimensions resources =
    Element.column [ Element.spacing 32, Element.centerX ]
        [ Element.column [ Element.spacing 16, Element.centerX ]
            (resources |> List.map Resource.view)
        ]

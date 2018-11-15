module Page.Learn.Post exposing (Post)

import Element exposing (Element)


type alias Post msg =
    { pageName : String
    , title : String
    , body : List (Element msg)
    }

module Page.Learn.Post exposing (Post)

import Dimensions exposing (Dimensions)
import Element exposing (Element)


type alias Post msg =
    { pageName : String
    , title : String
    , body : Dimensions -> List (Element msg)
    }

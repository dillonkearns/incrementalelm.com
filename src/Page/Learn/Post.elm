module Page.Learn.Post exposing (Post)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import View.Resource exposing (Resource)


type alias Post msg =
    { pageName : String
    , title : String
    , body : Dimensions -> List (Element msg)
    , resources : { title : Maybe String, items : List Resource }
    }

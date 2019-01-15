module Page.Learn.Post exposing (Post)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import View.Resource exposing (Resource)


type alias Post =
    { pageName : String
    , title : String
    , body : String
    , resources : { title : Maybe String, items : List Resource }
    }

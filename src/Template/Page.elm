module Template.Page exposing (..)

import Template


type alias Model =
    ()


type alias Msg =
    Never


template =
    Template.noStaticData { head = Debug.todo "" }
        |> Template.buildNoState
            { view = Debug.todo ""
            }

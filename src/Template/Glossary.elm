module Template.Glossary exposing (..)

import Element
import Template


type alias Model =
    ()


type alias Msg =
    Never


template : Template.Template_ templateMetadata ()
template =
    Template.noStaticData
        { head =
            \_ -> []
        }
        |> Template.buildNoState
            { view =
                \_ _ _ ->
                    { title = "", body = [ Element.none ] }
            }

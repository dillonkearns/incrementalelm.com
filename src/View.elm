module View exposing (Body(..), View, map, placeholder)

import Element exposing (Element)
import Html.Styled as Html exposing (Html)


type alias View msg =
    { title : String
    , body : Body msg
    }


type Body msg
    = ElmUi (List (Element msg))
    | Tailwind (List (Html msg))



--| Tailwind (List (Html msg))


map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn doc =
    { title = doc.title
    , body =
        case doc.body of
            ElmUi elements ->
                List.map (Element.map fn) elements |> ElmUi

            Tailwind nodes ->
                List.map (Html.map fn) nodes |> Tailwind
    }


placeholder : String -> View msg
placeholder moduleName =
    { title = "Placeholder - " ++ moduleName
    , body = Tailwind [ Html.text moduleName ]
    }

module View exposing (Body(..), View, freeze, freezableToHtml, htmlToFreezable, map, placeholder)

import Html


type alias View msg =
    { title : String
    , body : Body msg
    }


type Body msg
    = Tailwind (List (Html.Html msg))


map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn doc =
    { title = doc.title
    , body =
        case doc.body of
            Tailwind nodes ->
                List.map (Html.map fn) nodes |> Tailwind
    }


placeholder : String -> View msg
placeholder moduleName =
    { title = "Placeholder - " ++ moduleName
    , body = Tailwind [ Html.text moduleName ]
    }


type alias Freezable =
    Html.Html Never


freezableToHtml : Freezable -> Html.Html Never
freezableToHtml =
    identity


htmlToFreezable : Html.Html Never -> Freezable
htmlToFreezable =
    identity


freeze : Freezable -> Html.Html msg
freeze content =
    content
        |> freezableToHtml
        |> htmlToFreezable
        |> Html.map never

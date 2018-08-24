module View.FontAwesome exposing (icon)

import Element
import Html
import Html.Attributes


icon classString =
    Html.i [ Html.Attributes.class classString ] []
        |> Element.html

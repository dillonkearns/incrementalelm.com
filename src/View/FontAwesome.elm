module View.FontAwesome exposing (styledIcon)

import Element exposing (Element)
import Html
import Html.Attributes as Attr


styledIcon : String -> List (Element.Attribute msg) -> Element msg
styledIcon classString styles =
    Html.i [ Attr.class classString ] []
        |> Element.html
        |> Element.el styles

module Link exposing (link)

import Element exposing (Attribute, Element)
import Html.Attributes as Attr
import Path
import Route exposing (Route)


link : Route -> List (Attribute msg) -> Element msg -> Element msg
link route attrs label =
    Element.link
        ((Attr.attribute "elm-pages:prefetch" ""
            |> Element.htmlAttribute
         )
            :: attrs
        )
        { url = route |> Route.toPath |> Path.toAbsolute
        , label = label
        }

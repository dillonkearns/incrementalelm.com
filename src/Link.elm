module Link exposing (htmlLink, link)

import Element exposing (Attribute, Element)
import Html.Attributes as Attr
import Html.Styled
import Html.Styled.Attributes
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


htmlLink : List (Html.Styled.Attribute msg) -> Html.Styled.Html msg -> Route -> Html.Styled.Html msg
htmlLink attrs label route =
    Route.toLink
        (\routeAttrs ->
            Html.Styled.a
                (List.map Html.Styled.Attributes.fromUnstyled routeAttrs ++ attrs)
                [ label ]
        )
        route

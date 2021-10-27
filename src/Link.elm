module Link exposing (htmlLink, htmlLink2)

import Html.Styled
import Html.Styled.Attributes
import Route exposing (Route)


htmlLink : List (Html.Styled.Attribute msg) -> Html.Styled.Html msg -> Route -> Html.Styled.Html msg
htmlLink attrs label route =
    Route.toLink
        (\routeAttrs ->
            Html.Styled.a
                (List.map Html.Styled.Attributes.fromUnstyled routeAttrs ++ attrs)
                [ label ]
        )
        route


htmlLink2 : List (Html.Styled.Attribute msg) -> List (Html.Styled.Html msg) -> Route -> Html.Styled.Html msg
htmlLink2 attrs label route =
    Route.toLink
        (\routeAttrs ->
            Html.Styled.a
                (List.map Html.Styled.Attributes.fromUnstyled routeAttrs ++ attrs)
                label
        )
        route

module Link exposing (htmlLink)

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

module Link exposing (htmlLink, htmlLink2)

import Html.Styled
import Html.Styled.Attributes
import Route exposing (Route)
import UrlPath


htmlLink : List (Html.Styled.Attribute msg) -> Html.Styled.Html msg -> Route -> Html.Styled.Html msg
htmlLink attrs label route =
    Html.Styled.a
        (Html.Styled.Attributes.href (Route.toPath route |> UrlPath.toAbsolute) :: attrs)
        [ label ]


htmlLink2 : List (Html.Styled.Attribute msg) -> List (Html.Styled.Html msg) -> Route -> Html.Styled.Html msg
htmlLink2 attrs label route =
    Html.Styled.a
        (Html.Styled.Attributes.href (Route.toPath route |> UrlPath.toAbsolute) :: attrs)
        label

module Link exposing (htmlLink, htmlLink2)

import Html
import Html.Attributes as Attr
import Route exposing (Route)
import UrlPath


htmlLink : List (Html.Attribute msg) -> Html.Html msg -> Route -> Html.Html msg
htmlLink attrs label route =
    Html.a
        (Attr.href (Route.toPath route |> UrlPath.toAbsolute) :: attrs)
        [ label ]


htmlLink2 : List (Html.Attribute msg) -> List (Html.Html msg) -> Route -> Html.Html msg
htmlLink2 attrs label route =
    Html.a
        (Attr.href (Route.toPath route |> UrlPath.toAbsolute) :: attrs)
        label

module GoogleForm exposing (view)

import Element
import Html exposing (iframe)
import Html.Attributes exposing (attribute, src, style)


view formId =
    iframe
        [ src <| "https://docs.google.com/forms/d/e/" ++ formId ++ "/viewform?embedded=true"
        , style "frameborder" "0"
        , attribute "marginheight" "0"
        , attribute "marginwidth" "0"
        , style "height" "900px"
        ]
        []
        |> Element.html
        |> Element.el
            [ Element.width Element.fill
            , Element.height Element.fill
            ]

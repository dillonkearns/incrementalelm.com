module Crowdcast exposing (view)

import Element
import Html exposing (iframe)
import Html.Attributes exposing (attribute, src, style)


view crowdcastId =
    iframe
        [ style "width" "100%"
        , style "height" "800px"
        , style "frameborder" "0"
        , style "marginheight" "0"
        , style "marginwidth" "0"
        , Html.Attributes.attribute "allowtransparency" "true"
        , src "https://www.crowdcast.io/e/why-absinthe?navlinks=false&embed=true"
        , style "border" "1px solid #EEE"
        , style "border-radius" "3px"
        , attribute "allowfullscreen" "true"
        , attribute "webkitallowfullscreen" "true"
        , attribute "mozallowfullscreen" "true"
        , attribute "allow" "microphone; camera;"
        ]
        []
        |> Element.html
        |> Element.el
            [ Element.height Element.fill
            , Element.width Element.fill
            ]

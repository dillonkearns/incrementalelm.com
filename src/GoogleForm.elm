module GoogleForm exposing (view)

import Element
import Html exposing (div, iframe)
import Html.Attributes exposing (attribute, src, style)


view =
    iframe
        [ src "https://docs.google.com/forms/d/e/1FAIpQLSd7V15KXuoReco2xJzz70LD-d691hQJ-586XNjAmQVSkdYUsQ/viewform?embedded=true"
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

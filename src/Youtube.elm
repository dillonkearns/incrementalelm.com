module Youtube exposing (view)

import Element exposing (Element)
import Html exposing (..)
import Html.Attributes exposing (..)


view : String -> Element msg
view id =
    div
        [ class "embed-container"
        ]
        [ iframe
            [ attribute "allow" "accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
            , attribute "allowfullscreen" ""
            , attribute "frameborder" "0"
            , attribute "height" "390"
            , src <| "https://www.youtube-nocookie.com/embed/" ++ id
            , attribute "width" "640"
            ]
            []
        ]
        |> Element.html
        |> Element.el
            [ Element.centerX
            , Element.width (Element.maximum 640 Element.fill)
            ]

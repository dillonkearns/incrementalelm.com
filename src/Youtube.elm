module Youtube exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : String -> Html msg
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

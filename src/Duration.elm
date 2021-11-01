module Duration exposing (Duration, fromSeconds, view)

import Html.Styled as Html exposing (Html)


type alias Duration =
    { minutes : Int
    , seconds : Int
    }


fromSeconds : Int -> Duration
fromSeconds seconds =
    { minutes = seconds // 60
    , seconds = seconds |> Basics.modBy 60
    }


view : Duration -> Html msg
view duration =
    Html.span []
        [ Html.text <| String.fromInt duration.minutes
        , Html.text ":"
        , Html.text <| String.fromInt duration.seconds
        ]

module Duration exposing (Duration, fromSeconds, inMillis, view)

import Html exposing (Attribute, Html)


type alias Duration =
    { minutes : Int
    , seconds : Int
    }


inMillis : Duration -> Int
inMillis duration =
    (duration.minutes * 60 + duration.seconds) * 1000


fromSeconds : Int -> Duration
fromSeconds seconds =
    { minutes = seconds // 60
    , seconds = seconds |> Basics.modBy 60
    }


view : List (Attribute msg) -> Duration -> Html msg
view attrs duration =
    Html.span attrs
        [ Html.text <| String.fromInt duration.minutes
        , Html.text ":"
        , Html.text <| String.fromInt duration.seconds
        ]

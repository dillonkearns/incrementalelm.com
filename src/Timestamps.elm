module Timestamps exposing (Timestamps, data)

import BackendTask exposing (BackendTask)
import BackendTask.Custom
import FatalError exposing (FatalError)
import Json.Decode as Decode
import Json.Encode
import List.Extra
import Result.Extra
import Time


type alias Timestamps =
    { updated : Time.Posix
    , created : Time.Posix
    }


data : String -> BackendTask FatalError Timestamps
data filePath =
    BackendTask.Custom.run "gitTimestamps"
        (Json.Encode.string filePath)
        (Decode.string
            |> Decode.map (String.trim >> String.split "\n")
            |> Decode.map (List.map secondsStringToPosix)
            |> Decode.map Result.Extra.combine
            |> Decode.map
                (Result.withDefault
                    [ Time.millisToPosix 0
                    , Time.millisToPosix 0
                    ]
                )
            |> Decode.map (firstAndLast Timestamps >> Result.fromMaybe "Error")
            |> Decode.andThen
                (\result ->
                    case result of
                        Ok value ->
                            Decode.succeed value

                        Err error ->
                            Decode.fail error
                )
        )
        |> BackendTask.allowFatal


firstAndLast : (a -> a -> b) -> List a -> Maybe b
firstAndLast constructor list =
    Maybe.map2 constructor
        (List.head list)
        (List.Extra.last list)


secondsStringToPosix : String -> Result String Time.Posix
secondsStringToPosix posixTime =
    posixTime
        |> String.trim
        |> String.toInt
        |> Maybe.map (\unixTimeInSeconds -> (unixTimeInSeconds * 1000) |> Time.millisToPosix)
        |> Result.fromMaybe "Expected int"

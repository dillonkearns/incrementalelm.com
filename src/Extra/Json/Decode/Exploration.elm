module Extra.Json.Decode.Exploration exposing (iso8601)

import Iso8601
import Json.Decode.Exploration as Decode exposing (Decoder)
import Parser
import Time exposing (Posix)


iso8601 : Decoder Posix
iso8601 =
    Decode.andThen
        (\s ->
            case Iso8601.toTime s of
                Err deadEnds ->
                    Decode.fail <| Parser.deadEndsToString deadEnds

                Ok time ->
                    Decode.succeed time
        )
        Decode.string

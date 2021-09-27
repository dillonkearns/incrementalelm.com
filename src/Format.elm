module Format exposing (formatValue)

import Regex


formatValue : String -> String
formatValue value =
    value
        |> Regex.replace (reg "[\\\\;,\"]") (\{ match } -> "\\" ++ match)
        |> Regex.replace (reg "(?:\u{000D}\n|\u{000D}|\n)") (\_ -> "\\n")


reg : String -> Regex.Regex
reg string =
    Regex.fromString string
        |> Maybe.withDefault Regex.never

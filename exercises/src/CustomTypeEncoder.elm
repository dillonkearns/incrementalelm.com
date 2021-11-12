module CustomTypeEncoder exposing (main)

import Expect
import Json.Encode
import Test.Koan exposing (Test, describe, test)
import TsJson.Encode as TsEncode
import TsJson.Type


main =
    describe "Encoding Custom Types"
        [ test "literal" <|
            \() ->
                solution__ (TsEncode.literal (Json.Encode.string "hi!"))
                    |> TsEncode.tsType
                    |> TsJson.Type.toTypeScript
                    |> Expect.equal "\"hi!\""
        , test "you can map an encoder" <|
            \() ->
                { message = "Hello" }
                    |> TsEncode.runExample
                        (TsEncode.string
                            |> TsEncode.map
                                (\value ->
                                    solution__ value.message
                                )
                        )
                    |> Expect.equal
                        { output = "\"Hello\""
                        , tsType = "string"
                        }
        , test "dot-notation is equivalent to the long-form lambda syntax" <|
            \() ->
                { message = "Hello" }
                    |> solution__ .message
                    |> Expect.equal
                        "Hello"
        , test "you can even do transformations in the mapping like turning a string to uppercase" <|
            \() ->
                "hello"
                    |> TsEncode.runExample
                        (TsEncode.string
                            |> TsEncode.map (solution__ String.toUpper)
                        )
                    |> Expect.equal
                        { output = "\"HELLO\""
                        , tsType = "string"
                        }
        , test "source of truth" <|
            \() ->
                ()
                    |> TsEncode.runExample
                        (TsEncode.literal (Json.Encode.string "hi!"))
                    --|> TsJson.Type.toTypeScript
                    |> Expect.equal
                        { output = "\"hi!\""
                        , tsType = "\"hi!\""
                        }
        ]
        |> Test.Koan.program


solution__ : a -> a
solution__ value =
    --Debug.todo "FIXME"
    value

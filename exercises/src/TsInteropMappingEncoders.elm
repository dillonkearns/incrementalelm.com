module TsInteropMappingEncoders exposing (main)

import Expect
import Json.Encode
import Test.Koan exposing (Test, describe, test)
import TsJson.Encode as TsEncode
import TsJson.Type


main =
    describe "Encoding Custom Types"
        [ test "TsEncode.literal can encode a string literal like \"hello\"" <|
            \() ->
                TsEncode.literal
                    (Json.Encode.string (solution__ "hello"))
                    --solution__ (x____replace me____x)
                    |> TsEncode.tsType
                    |> TsJson.Type.toTypeScript
                    |> Expect.equal "\"hello\""
        , test "a literal doesn't have to be a string, it can also be an int" <|
            \() ->
                TsEncode.literal
                    (Json.Encode.int (solution__ 123))
                    |> TsEncode.tsType
                    |> TsJson.Type.toTypeScript
                    |> Expect.equal "123"
        , test "you can combine two literals in TypeScript with a union" <|
            \() ->
                TsEncode.union
                    (\v200 v404 pageFound ->
                        if pageFound then
                            v200

                        else
                            v404
                    )
                    |> TsEncode.variantLiteral (Json.Encode.int 200)
                    |> TsEncode.variantLiteral (solution__ (Json.Encode.int 404))
                    |> TsEncode.buildUnion
                    |> TsEncode.tsType
                    |> TsJson.Type.toTypeScript
                    |> Expect.equal "404 | 200"
        , test "you can map an encoder" <|
            \() ->
                { message = "Hello" }
                    |> TsEncode.runExample
                        (TsEncode.string
                            |> TsEncode.map
                                (\value ->
                                    value.message
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


type FILL_ME_IN
    = Blank


me____x : FILL_ME_IN
me____x =
    Blank


x____replace : FILL_ME_IN -> a
x____replace _ =
    Debug.todo "FILL IN THE BLANK"


x____replace2 : a
x____replace2 =
    Debug.todo ""

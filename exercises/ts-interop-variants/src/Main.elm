module Main exposing (main)

import Expect
import Json.Encode
import Test.Koan exposing (Test, describe, test)
import TsJson.Encode as TsEncode exposing (required)
import TsJson.Type


type FromElm
    = Alert
        { message : String
        , kind : String
        }
    | AttemptLogIn { username : String }
    | SaveToLocalStorage
        { key : String
        , value : String
        }


main =
    describe "Encoding Custom Types"
        [ test "TsEncode.variantTagged lets you handle new variants with additional tags in Discriminated Unions" <|
            \() ->
                TsEncode.union
                    (\vAlert vAttemptLogIn vSaveToLocalStorage value ->
                        case value of
                            Alert string ->
                                vAlert string

                            AttemptLogIn record ->
                                vAttemptLogIn record

                            SaveToLocalStorage record ->
                                vSaveToLocalStorage record
                    )
                    |> TsEncode.variantTagged "alert"
                        (TsEncode.object
                            [ required "message" (\value -> value.message) TsEncode.string
                            , required "logKind" (\value -> value.kind) TsEncode.string
                            ]
                        )
                    |> TsEncode.variantTagged "attemptLogIn"
                        (TsEncode.object
                            [ required "username" (\value -> value.username) TsEncode.string
                            ]
                        )
                    |> x____replace_me____x
                        (TsEncode.object
                            [ required "key" (\value -> value.key) TsEncode.string
                            , required "value" (\value -> value.value) TsEncode.string
                            ]
                        )
                    |> TsEncode.buildUnion
                    |> TsEncode.tsType
                    |> TsJson.Type.toTypeScript
                    |> Expect.equal
                        """{ data : { key : string; value : string }; tag : "saveToLocalStorage" } | { data : { username : string }; tag : "attemptLogIn" } | { data : { logKind : string; message : string }; tag : "alert" }"""
        ]
        |> Test.Koan.program


solution__ : a -> a
solution__ value =
    value


x____replace_me____x : a -> b
x____replace_me____x _ =
    Debug.todo "FILL IN THE BLANK"

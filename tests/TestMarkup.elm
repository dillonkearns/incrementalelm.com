module TestMarkup exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Mark
import MarkParser
import Page
import Page.Home
import Test exposing (..)


suite : Test
suite =
    test "markup is valid" <|
        \() ->
            Page.all
                |> List.filterMap
                    (\page ->
                        case page.body |> Mark.parse (MarkParser.document []) of
                            Err error ->
                                String.join "\n"
                                    [ page.title
                                    , error |> Debug.toString
                                    ]
                                    |> Just

                            Ok _ ->
                                Nothing
                    )
                |> Expect.equal []

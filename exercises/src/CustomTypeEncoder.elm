module Main exposing (main)

import Expect
import Html exposing (Html, div, h1, text)
import Random
import Test exposing (Test, describe, test)
import Test.Runner.Html exposing (defaultConfig, hidePassedTests, showPassedTests, viewResults)


config =
    Random.initialSeed 10000 |> defaultConfig |> showPassedTests


main : Html msg
main =
    div []
        [ h1 [] [ text "My Test Suite" ]
        , div [] [ viewResults config myTestSuite ]
        ]


isPalindrome : String -> Bool
isPalindrome input =
    let
        letters =
            String.toList input
    in
    letters == List.reverse letters


myTestSuite : Test
myTestSuite =
    describe "`isPalindrome`"
        [ test "called with a valid palindrome should return true" <|
            \_ -> Expect.true "should be true" (isPalindrome "kayak")
        , test "called with a non-palindrome string should return false" <|
            \_ -> Expect.false "should be false" (isPalindrome "canoe")
        , test "called with a palindrome with various case should not be case-sensitive" <|
            \_ -> Expect.true "should not be case-sensitive" (isPalindrome "Racecar")
        , test "called with a palindrome should be punctuation-insensitive" <|
            \_ -> Expect.true "should be punctuation-insensitive" (isPalindrome "Eva, can I see bees in a cave?")
        ]

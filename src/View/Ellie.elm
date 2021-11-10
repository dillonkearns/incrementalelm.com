module View.Ellie exposing (view)

import Css
import DataSource exposing (DataSource)
import DataSource.Http
import EllieApi.InputObject
import EllieApi.Mutation
import EllieApi.Object.Revision
import EllieApi.Scalar exposing (PrettyId(..))
import Graphql.Document
import Graphql.Operation exposing (RootMutation)
import Graphql.SelectionSet exposing (SelectionSet)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr exposing (css)
import Json.Encode as Encode
import Secrets


view : String -> Html msg
view ellieId =
    Html.iframe
        [ Attr.style "width" "100%"
        , Attr.style "height" "100%"
        , Attr.style "border" "0"
        , Attr.style "overflow" "hidden"
        , Attr.sandbox "allow-modals allow-forms allow-popups allow-scripts allow-same-origin"
        , Attr.src <| "https://ellie-app.com/embed/" ++ ellieId
        , css
            [ Css.minHeight (Css.px 500)
            ]
        ]
        []


dataSource : DataSource (Html msg)
dataSource =
    create
        |> staticGraphqlRequest
        |> DataSource.map
            (\(PrettyId ellieId) ->
                view ellieId
            )


create : SelectionSet PrettyId RootMutation
create =
    EllieApi.Mutation.createRevision
        { inputs =
            EllieApi.InputObject.buildRevisionInput
                { elmCode = """module Main exposing (main)

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
            \\_ -> Expect.true "should be true" (isPalindrome "kayak")
        , test "called with a non-palindrome string should return false" <|
            \\_ -> Expect.false "should be false" (isPalindrome "canoe")
        , test "called with a palindrome with various case should not be case-sensitive" <|
            \\_ -> Expect.true "should not be case-sensitive" (isPalindrome "Racecar")
        , test "called with a palindrome should be punctuation-insensitive" <|
            \\_ -> Expect.true "should be punctuation-insensitive" (isPalindrome "Eva, can I see bees in a cave?")
        ]
                """
                , htmlCode = """<html>
<head>
  <style>
    .test-pass {
      color: green;
    }
    .test-fail {
      color: red;
    }
  </style>
</head>
<body>
  <main></main>
  <script>
    var app = Elm.Main.init({ node: document.querySelector('main') })
    // you can use ports and stuff here
  </script>
</body>
</html>
"""
                , packages =
                    [ { name = "elm/browser", version = "1.0.2" }
                    , { name = "elm/core", version = "1.0.5" }
                    , { name = "elm/html", version = "1.0.0" }
                    , { name = "jgrenat/elm-html-test-runner", version = "1.0.3" }
                    , { name = "elm-explorations/test", version = "1.2.2" }
                    , { name = "elm/random", version = "1.0.0" }
                    ]
                        |> List.map
                            (\info ->
                                EllieApi.InputObject.buildElmPackageInput
                                    { name = EllieApi.Scalar.ElmName info.name
                                    , version = EllieApi.Scalar.ElmVersion info.version
                                    }
                            )
                , termsVersion = 4
                }
                identity
        }
        EllieApi.Object.Revision.id


staticGraphqlRequest : SelectionSet value RootMutation -> DataSource value
staticGraphqlRequest selectionSet =
    DataSource.Http.unoptimizedRequest
        (Secrets.succeed
            { url = "https://ellie-app.com/api"
            , method = "POST"
            , headers = []
            , body =
                DataSource.Http.jsonBody
                    (Encode.object
                        [ ( "query"
                          , selectionSet
                                |> Graphql.Document.serializeMutation
                                |> Encode.string
                          )
                        ]
                    )
            }
        )
        (selectionSet
            |> Graphql.Document.decoder
            |> DataSource.Http.expectUnoptimizedJson
        )

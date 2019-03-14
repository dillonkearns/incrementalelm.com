module View.CodeSnippet exposing (codeEditor)

import Element exposing (Element)
import Html exposing (Attribute, Html)
import Html.Attributes exposing (property)
import Html.Events exposing (on)
import Json.Encode as Encode exposing (Value)


codeEditor : String -> Element msg
codeEditor snippet =
    Html.node "code-editor" [ editorValue snippet ] []
        |> Element.html


editorValue : String -> Attribute msg
editorValue value =
    value
        |> String.trim
        |> Encode.string
        |> property "editorValue"

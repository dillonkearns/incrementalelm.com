module View.CodeSnippet exposing (codeEditor, editorValue)

import Html exposing (Attribute, Html)
import Html.Attributes exposing (property)
import Html.Events exposing (on)
import Json.Encode as Encode exposing (Value)


codeEditor : String -> List (Attribute msg) -> Html msg
codeEditor snippet attributes =
    Html.node "code-editor" (editorValue snippet :: attributes) []


editorValue : String -> Attribute msg
editorValue value =
    value
        |> String.trim
        |> Encode.string
        |> property "editorValue"

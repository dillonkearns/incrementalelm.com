module View.CodeSnippet exposing (codeEditor, editorValue)

import Html exposing (Attribute, Html)
import Html.Attributes exposing (property)
import Html.Events exposing (on)
import Json.Encode as Encode exposing (Value)


{-| Create a code editor Html element.
-}
codeEditor : String -> List (Attribute msg) -> Html msg
codeEditor snippet attributes =
    Html.node "code-editor" (editorValue snippet :: attributes) []


{-| This is how you set the contents of the code editor.
-}
editorValue : String -> Attribute msg
editorValue value =
    property "editorValue" <|
        Encode.string value

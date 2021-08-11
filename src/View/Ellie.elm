module View.Ellie exposing (view)

import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr exposing (css)


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

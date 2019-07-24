module View.Ellie exposing (view)

import Element exposing (..)
import Html
import Html.Attributes as Attr


view : String -> Element msg
view ellieId =
    Html.iframe
        [ Attr.style "width" "100%"
        , Attr.style "height" "100%"
        , Attr.style "border" "0"
        , Attr.style "overflow" "hidden"
        , Attr.sandbox "allow-modals allow-forms allow-popups allow-scripts allow-same-origin"
        , Attr.src <| "https://ellie-app.com/embed/" ++ ellieId
        ]
        []
        |> Element.html
        |> Element.el
            [ width fill
            , height (px 400)
            ]

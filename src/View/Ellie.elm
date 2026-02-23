module View.Ellie exposing (view)

import Html exposing (Html)
import Html.Attributes as Attr
import Tailwind as Tw exposing (classes)
import Tailwind.Theme exposing (s1)


view : String -> Html msg
view ellieId =
    Html.div []
        [ Html.code []
            [ Html.code
                [ classes
                    [ Tw.raw "bg-selection-background"
                    , Tw.raw "rounded-lg"
                    , Tw.p s1
                    ]
                ]
                [ Html.text ("ellie-app " ++ ellieId) ]
            ]
        , Html.iframe
            [ Attr.style "width" "100%"
            , Attr.style "height" "100%"
            , Attr.style "border" "0"
            , Attr.style "overflow" "hidden"
            , Attr.sandbox "allow-modals allow-forms allow-popups allow-scripts allow-same-origin"
            , Attr.src <| "https://ellie-app.com/embed/" ++ ellieId
            , Attr.style "min-height" "500px"
            ]
            []
        ]

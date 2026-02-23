module Widget.Signup exposing (view, view2)

import Html exposing (Html)
import Html.Attributes as Attr
import Tailwind as Tw exposing (classes)
import Tailwind.Theme exposing (s4)
import View.DripSignupForm


view2 : String -> String -> List (Html msg) -> Html msg
view2 buttonText formId body =
    Html.div
        [ classes
            [ Tw.flex
            , Tw.justify_center
            , Tw.raw "border-foreground"
            ]
        ]
        [ Html.div
            [ classes
                [ Tw.p s4
                , Tw.raw "max-w-lg"
                , Tw.raw "shadow-xl"
                , Tw.raw "border-foreground-light"
                , Tw.border_2
                , Tw.raw "border-solid"
                ]
            ]
            [ Html.div
                [ classes [ Tw.text_center ]
                ]
                body
            , View.DripSignupForm.viewNew buttonText formId { maybeReferenceId = Nothing }
            , Html.p [] [ Html.text "We'll never share your email. Unsubscribe any time." ]
            ]
        ]


view : Html msg
view =
    Html.div
        [ classes
            [ Tw.flex
            , Tw.justify_center
            , Tw.raw "border-foreground"
            ]
        ]
        [ Html.div
            [ classes
                [ Tw.p s4
                , Tw.raw "max-w-lg"
                , Tw.raw "shadow-xl"
                , Tw.raw "border-foreground-light"
                , Tw.border_2
                , Tw.raw "border-solid"
                ]
            ]
            [ Html.p
                []
                [ Html.text "Sign up to get my latest Elm posts and course notifications in your inbox."
                ]
            , View.DripSignupForm.viewNew2 "Subscribe" "906002494" { maybeReferenceId = Nothing }
            , Html.p [] [ Html.text "Pure Elm content. Unsubscribe any time." ]
            ]
        ]

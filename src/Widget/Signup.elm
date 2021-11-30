module Widget.Signup exposing (view, view2)

import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css)
import Tailwind.Utilities as Tw
import View.DripSignupForm


view2 : String -> String -> List (Html msg) -> Html msg
view2 buttonText formId body =
    Html.div
        [ css
            [ Tw.flex
            , Tw.justify_center
            , Tw.border_foreground
            ]
        ]
        [ Html.div
            [ css
                [ Tw.p_4
                , Tw.max_w_lg
                , Tw.shadow_xl
                , Tw.border_foregroundLight
                , Tw.border_2
                , Tw.border_solid
                ]
            ]
            [ Html.div
                [ css [ Tw.text_center ]
                ]
                body
            , View.DripSignupForm.viewNew buttonText formId { maybeReferenceId = Nothing }
            , Html.p [] [ Html.text "We'll never share your email. Unsubscribe any time." ]
            ]
        ]


view : Html msg
view =
    Html.div
        [ css
            [ Tw.flex
            , Tw.justify_center
            , Tw.border_foreground
            ]
        ]
        [ Html.div
            [ css
                [ Tw.p_4
                , Tw.max_w_lg
                , Tw.shadow_xl
                , Tw.border_foregroundLight
                , Tw.border_2
                , Tw.border_solid
                ]
            ]
            [ Html.p
                [ css []
                ]
                [ Html.text "Sign up to get my latest Elm posts and course notifications in your inbox."
                ]
            , View.DripSignupForm.viewNew2 "Subscribe" "906002494" { maybeReferenceId = Nothing }
            , Html.p [ css [] ] [ Html.text "Pure Elm content. Unsubscribe any time." ]
            ]
        ]

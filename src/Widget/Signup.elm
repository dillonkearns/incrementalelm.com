module Widget.Signup exposing (view2)

import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css)
import Tailwind.Utilities as Tw
import View.DripSignupForm


view2 : String -> String -> List (Html msg) -> Html msg
view2 buttonText formId body =
    Html.div [ css [ Tw.flex, Tw.justify_center ] ]
        [ Html.div
            [ css
                [ Tw.p_4
                , Tw.max_w_lg
                , Tw.shadow_xl
                , Tw.border_foreground
                , Tw.border_2
                ]
            ]
            [ Html.div
                [ --Font.center
                  --, Element.spacing 30
                  --, Element.centerX
                  css [ Tw.text_center ]
                ]
                body
            , View.DripSignupForm.viewNew buttonText formId { maybeReferenceId = Nothing }
            , Html.p [] [ Html.text "We'll never share your email. Unsubscribe any time." ]
            ]
        ]

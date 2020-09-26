module Widget.Signup exposing (view)

import Element exposing (Element)
import Element.Border
import Element.Font as Font
import View.DripSignupForm


view : String -> String -> List (Element msg) -> Element msg
view buttonText formId body =
    [ Element.column
        [ Font.center
        , Element.spacing 30
        , Element.centerX
        ]
        body
    , View.DripSignupForm.viewNew buttonText formId { maybeReferenceId = Nothing }
        |> Element.html
        |> Element.el [ Element.width Element.fill ]
    , [ Element.text "We'll never share your email. Unsubscribe any time." ]
        |> Element.paragraph
            [ Font.color (Element.rgba255 0 0 0 0.5)
            , Font.size 14
            , Font.center
            ]
    ]
        |> Element.column
            [ Element.width Element.fill
            , Element.padding 20
            , Element.spacing 20
            , Element.Border.shadow { offset = ( 0, 0 ), size = 1, blur = 4, color = Element.rgb 0.8 0.8 0.8 }
            , Element.mouseOver
                [ Element.Border.shadow { offset = ( 0, 0 ), size = 1, blur = 4, color = Element.rgb 0.85 0.85 0.85 } ]
            , Element.width (Element.fill |> Element.maximum 500)
            , Element.centerX
            ]
        |> Element.el []

module Page.Signup exposing (view)

import Dict
import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Route
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
import View.DripSignupForm
import View.FontAwesome
import View.SignupForm


view : Route.SignupDetails -> Dimensions -> Element.Element msg
view signupDetails dimensions =
    Element.column
        [ Style.fontSize.medium
        , Element.width Element.fill
        , Element.height Element.fill
        , Element.padding
            (if Dimensions.isMobile dimensions then
                20

             else
                50
            )
        , Element.spacing 30
        , Element.width (Element.fill |> Element.maximum 900)
        , Element.centerX
        ]
        [ preamble signupDetails.formName
        , View.DripSignupForm.view signupDetails |> Element.html
        ]


preamble maybeFormName =
    maybeFormName
        |> Maybe.andThen (\formName -> dict |> Dict.get formName)
        |> Maybe.withDefault defaultForm
        |> (\details ->
                Element.text details.introContent
           )


defaultForm =
    { formId = "863568508", introContent = "Sign up for my list." }


dict =
    Dict.fromList
        [ ( "graphql-workshop", { formId = "375406512", introContent = "" } )
        , ( "graphql", { formId = "375406512", introContent = "" } )
        , ( "tiny-steps"
          , { formId = "863568508"
            , introContent = "Sign up here to get see our 3-minute walk-trhough video of the steps from Moving Faster with Tiny Steps in Elm!"
            }
          )
        ]


contactButton =
    Element.newTabLink
        [ Element.centerX ]
        { url = "mailto:info@incrementalelm.com"
        , label =
            Style.Helpers.button
                { fontColor = .mainBackground
                , backgroundColor = .highlight
                , size = fontSize.body
                }
                [ envelopeIcon |> Element.el []
                , Element.text "info@incrementalelm.com"
                ]
        }


envelopeIcon =
    View.FontAwesome.icon "far fa-envelope"


paragraph styles content =
    [ Element.text content ]
        |> Element.paragraph ([ Element.width Element.fill ] ++ styles)

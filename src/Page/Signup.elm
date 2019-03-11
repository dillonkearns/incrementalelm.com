module Page.Signup exposing (view)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
import View.DripSignupForm
import View.FontAwesome
import View.SignupForm


view : Maybe String -> Dimensions -> Element.Element msg
view maybeReferenceId dimensions =
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
        [ preamble
        , View.DripSignupForm.view maybeReferenceId |> Element.html
        ]


preamble =
    Element.column
        [ Element.spacing 10
        ]
        [ paragraph [] "Mark your calendar! We're running an Elm GraphQL Fundamentals Workshop."
        , Element.image [ Element.width (Element.px 250), Element.centerX, Element.paddingXY 0 25 ]
            { src = "/assets/graphql-workshop.png"
            , description = "GraphQL Workshop"
            }
        , Style.Helpers.smallTitle <| Element.text "Thursday, February 28, 2019"
        , Style.Helpers.smallTitle <| Element.text "1:00 PM – 5:00 PM PST"
        , paragraph [] "Sign up here to grab your discount code! We'll send you the latest news about Elm and GraphQL, and you can unsubscribe any time."
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

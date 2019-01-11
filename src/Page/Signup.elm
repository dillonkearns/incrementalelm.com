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
import View.FontAwesome
import View.SignupForm


view : Dimensions -> Element.Element msg
view dimensions =
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
        , Element.html View.SignupForm.view |> Element.el [ Element.Border.width 1, Element.padding 20, Element.width Element.fill ]
        , paragraph
            [ Style.fontSize.title
            , Style.fonts.title
            , Element.Font.center
            , Element.width Element.fill
            ]
            "Contact Incremental Elm"
        , (if Dimensions.isMobile dimensions then
            Element.column [ Element.spacing 50 ]

           else
            Element.row [ Element.spacing 50 ]
          )
            [ Element.image [ Element.width Element.fill, Element.centerX ]
                { src = "/assets/contact.jpg"
                , description = "Contact Image"
                }
            , Element.column [ Element.spacing 50 ]
                [ Element.paragraph
                    [ Element.width Element.fill
                    , Style.fontSize.body
                    , Style.fonts.body
                    ]
                    [ Element.text "A great way to get in touch with us is connect with us is to request "
                    , Element.newTabLink [ Element.Font.color palette.highlight ]
                        { url = "/coaches", label = Element.text "one of our free intro talks" }
                    , Element.text ". This can help to get a sense of whether Elm might be a good fit for your team. You can also "
                    , Element.newTabLink [ Element.Font.color palette.highlight ]
                        { url = "/coaches", label = Element.text "learn more about our coaches" }
                    , Element.text " and their conference talks and open source contributions. Or just send us a message and say hello!"
                    ]
                , contactButton
                ]
            ]
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

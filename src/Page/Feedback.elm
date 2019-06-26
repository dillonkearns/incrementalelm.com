module Page.Feedback exposing (view)

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
        [ Style.Helpers.title <| Element.text "Thank You!"
        , preamble
        , feedbackFormView
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
                    [ Element.text "We're here to help! Our mission is to equip Elm teams with the skills to write Elm like a master! Get in touch if you're interested in our monthly coaching call program. Or just send us a message and say hello!"
                    ]
                , contactButton
                ]
            ]
        ]


preamble =
    Element.column
        [ Element.spacing 10
        , Element.centerX
        ]
        [ Element.image [ Element.width (Element.px 250), Element.centerX, Element.paddingXY 0 25 ]
            { src = "/assets/graphql-workshop.png"
            , description = "GraphQL Workshop"
            }
        , Style.Helpers.smallTitle <| Element.text "Thursday, March 21, 2019"
        , Style.Helpers.smallTitle <| Element.text "1:00 PM – 5:00 PM PST"
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


feedbackFormView =
    -- <iframe src= width="640" height="1059" frameborder="0" marginheight="0" marginwidth="0">Loading...</iframe>
    Html.iframe
        [ Html.Attributes.src "https://docs.google.com/forms/d/e/1FAIpQLSd-BDaY-xY97zjiTmoAJ0xWrgkDLf0x7_jzTlpaiT0vGggHjw/viewform?embedded=true"
        , Html.Attributes.width 640
        , Html.Attributes.height 1059

        -- , Html.Attributes.frame 1059
        -- , Html.Attributes.style "width" "100%"
        ]
        []
        |> Element.html
        |> Element.el [ Element.centerX ]


envelopeIcon =
    View.FontAwesome.icon "far fa-envelope"


paragraph styles content =
    [ Element.text content ]
        |> Element.paragraph ([ Element.width Element.fill ] ++ styles)

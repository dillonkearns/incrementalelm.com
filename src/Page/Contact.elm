module Page.Contact exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
import View.FontAwesome


view :
    { width : Float
    , height : Float
    , device : Element.Device
    }
    -> Element.Element msg
view dimensions =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.padding
            (if dimensions.width <= 1000 then
                20

             else
                50
            )
        , Element.spacing 30
        , Element.width (Element.fill |> Element.maximum 900)
        , Element.centerX
        ]
        [ paragraph
            [ Style.fontSize.title
            , Style.fonts.title
            , Element.Font.center
            , Element.width Element.fill
            ]
            "Contact Incremental Elm"
        , (if dimensions.width <= 1000 then
            Element.column [ Element.spacing 50 ]

           else
            Element.row [ Element.spacing 50 ]
          )
            [ Element.image [ Element.width Element.fill, Element.centerX ]
                -- { src = "https://images.unsplash.com/photo-1522223142907-0fbfb9c571c1?ixlib=rb-0.3.5&s=0191cf141320fcc6db4202c0e84a2906&auto=format&fit=crop&w=2226&q=80"
                { src = "https://images.unsplash.com/photo-1511847628852-980ec678a438?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=13f1461f96f13dc4ddadb4a37d33c0bc&auto=format&fit=crop&w=2250&q=80"
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

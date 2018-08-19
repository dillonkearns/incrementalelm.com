module Page.Home exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Style exposing (fontSize, fonts, palette)


wrappedText contents =
    Element.paragraph [] [ Element.text contents ]


bulletPoint content =
    "→ "
        ++ content
        |> wrappedText
        |> Element.el
            [ fonts.body
            , fontSize.body
            ]


view :
    { width : Float
    , height : Float
    , device : Element.Device
    }
    -> List (Element.Element msg)
view dimensions =
    [ whyElmSection
    , whyIncrementalSection
    , servicesSection dimensions
    , contactSection
    ]


contactSection =
    Element.column
        [ Background.color palette.highlight
        , Element.height (Element.shrink |> Element.minimum 300)
        , Element.width Element.fill
        ]
        [ Element.el
            [ Element.Font.color palette.bold
            , Element.centerX
            , fontSize.title
            , fonts.body
            , Element.padding 30
            ]
            ("Get in touch"
                |> wrappedText
                |> Element.el
                    [ fonts.title
                    , Element.centerX
                    , Element.Font.center
                    , Element.Font.color palette.mainBackground
                    ]
            )
        , contactButton
        ]


contactButton =
    Element.link
        [ Element.centerX
        ]
        { url =
            "mailto:info@incrementalelm.com"
        , label =
            button
                { fontColor = palette.mainBackground
                , backgroundColor = palette.bold
                }
                [ envelopeIcon |> Element.el []
                , Element.text "info@incrementalelm.com"
                ]
        }


button { fontColor, backgroundColor } children =
    Element.row
        [ Element.spacing 20
        , Element.Font.color fontColor
        , Background.color backgroundColor
        , Element.padding 15
        , Element.Border.rounded 10
        , fontSize.body
        ]
        children


envelopeIcon =
    Html.i [ Html.Attributes.class "far fa-envelope" ] []
        |> Element.html


servicesSection dimensions =
    Element.column
        [ Background.color palette.main
        , Element.height (Element.shrink |> Element.minimum 300)
        , Element.width Element.fill
        ]
        [ Element.column
            [ Element.Font.color palette.bold
            , Element.centerY
            , Element.width Element.fill
            , fontSize.title
            , fonts.body
            , Element.spacing 25
            , Element.padding 30
            ]
            [ "Services"
                |> wrappedText
                |> Element.el
                    [ fonts.title
                    , Element.centerX
                    , Element.Font.center
                    ]
            , iterations dimensions
            ]
        ]


iterations dimensions =
    (if dimensions.width > 1000 then
        Element.row
            [ Element.spaceEvenly
            , Element.width Element.fill
            , Element.padding 50
            ]

     else
        Element.column
            [ Element.width Element.fill
            , Element.padding 20
            ]
    )
        [ iteration 0
            [ "Elm Fundamentals training for your team"
            , "Ship Elm code to production in under a week"
            , "Master The Elm Architecture"
            , "Fundamentals of Test-Driven Development in Elm"
            ]
        , iteration 1
            [ "Reuse and scaling patterns"
            , "Advanced JavaScript interop techniques"
            , "Choose the right Elm styling approach for your environment"
            ]
        , iteration 2
            [ "Transition your codebase to a full Single-Page Elm App"
            , "Master Elm architectural patterns"
            ]
        ]


iteration iterationNumber bulletPoints =
    [ iterationBubble iterationNumber
    , List.map bulletPoint bulletPoints
        |> Element.column
            [ Element.centerX
            , Element.spacing 30
            ]
    ]
        |> Element.column
            [ Element.spacing 50
            , Element.alignTop
            , Element.width Element.fill
            ]


faTransform =
    attribute "data-fa-transform"


iterationBubble iterationNumber =
    Element.none
        |> Element.el
            [ Background.color palette.highlight
            , Element.paddingXY 130 130
            , Element.Border.rounded 10000
            , Element.inFront
                ([ Element.text "Iteration "
                 , Element.text (String.fromInt iterationNumber)
                 ]
                    |> Element.paragraph
                        [ Element.Font.color white
                        , fonts.title
                        , Element.centerX
                        , Element.centerY
                        , Element.Font.center
                        , fontSize.medium
                        , Element.Font.bold
                        ]
                )
            ]
        |> Element.el
            [ Element.centerX
            ]


whyElmSection =
    bulletSection
        { backgroundColor = palette.highlightBackground
        , fontColor = Element.rgb 255 255 255
        , headingText = "Want a highly reliable & maintainable frontend?"
        , bulletContents =
            [ "Zero runtime exceptions"
            , "Rely on language guarantees instead of discipline"
            , "Predictable code - no globals or hidden side-effects"
            ]
        , append =
            Element.link
                [ Element.centerX
                ]
                { url = "/#why-elm"
                , label =
                    "Read About Why Elm?"
                        |> wrappedText
                        |> Element.el
                            [ Element.Border.rounded 10
                            , Background.color palette.light
                            , Element.Font.color white
                            , Element.padding 15
                            , fontSize.small
                            , Element.pointer
                            , Element.mouseOver
                                [ Background.color (elementRgb 25 151 192)
                                ]
                            ]
                }
        }


elementRgb red green blue =
    Element.rgb (red / 255) (green / 255) (blue / 255)


white =
    elementRgb 255 255 255


bulletSection { backgroundColor, fontColor, headingText, bulletContents, append } =
    Element.column
        [ Background.color backgroundColor
        , Element.height (Element.shrink |> Element.minimum 300)
        , Element.width Element.fill
        ]
        [ Element.column
            [ Element.Font.color fontColor
            , Element.centerY
            , Element.width Element.fill
            , fontSize.title
            , fonts.body
            , Element.spacing 25
            , Element.padding 30
            ]
            (List.concat
                [ [ headingText
                        |> wrappedText
                        |> Element.el
                            [ fonts.title
                            , Element.centerX
                            , Element.Font.center
                            ]
                  ]
                , List.map bulletPoint bulletContents
                , [ append ]
                ]
            )
        ]


whyIncrementalSection =
    bulletSection
        { backgroundColor = palette.mainBackground
        , fontColor = palette.bold
        , headingText = "How do I start?"
        , bulletContents =
            [ "One tiny step at a time!"
            , "See how Elm fits in your environment: learn the fundamentals and ship something in less than a week!"
            , "Elm is all about reliability. Incremental Elm Consulting gets you there reliably"
            ]
        , append = Element.none
        }

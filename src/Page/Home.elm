module Page.Home exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Style exposing (fonts, palette)


wrappedText contents =
    Element.paragraph [] [ Element.text contents ]


bulletPoint content =
    "→ "
        ++ content
        |> wrappedText
        |> Element.el
            [ fonts.body
            , Element.Font.size 25
            ]


view =
    [ whyElmSection
    , whyIncrementalSection
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
                            , Element.Font.size 18
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
            , Element.Font.size 55
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

module Style.Helpers exposing (blockQuote, button, link)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Style


button { fontColor, backgroundColor, size } children =
    Element.row
        [ Element.spacing 20
        , Element.Font.color (fontColor Style.palette)
        , Element.mouseOver
            [ Background.color (backgroundColor Style.hoverPalette)
            ]
        , Background.color (backgroundColor Style.palette)
        , Element.padding 13
        , Element.Border.rounded 10
        , Style.fontSize.body
        , size
        ]
        children


link { url, content } =
    Element.newTabLink [ Element.Font.color Style.palette.highlight ]
        { url = url, label = Element.text content }


blockQuote :
    Dimensions
    -> { content : String, author : Element msg }
    -> Element msg
blockQuote dimensions { content, author } =
    if Dimensions.isMobile dimensions then
        Element.column
            [ Element.width Element.fill
            , Element.paddingXY 30 30
            , Element.spacing 30
            , Style.shadow
            ]
            [ Element.paragraph
                [ Style.fonts.body
                , Style.fonts.body
                , Style.fontSize.medium
                , Element.spacing 12
                ]
                [ Element.text content |> Element.el [] ]
            , author
            ]

    else
        Element.row
            [ Element.width Element.fill
            , Style.fonts.body
            , Element.padding 10
            , Element.Border.widthEach { bottom = 0, left = 15, right = 0, top = 0 }
            , Element.Border.color quoteColor
            ]
            [ Element.text "“"
                |> Element.el
                    [ Style.fontSize.quotation
                    , Element.Font.color quoteColor
                    , Element.alignTop
                    ]
            , Element.column
                [ Element.width Element.fill
                , Element.paddingXY 30 10
                , Element.spacing 30
                ]
                [ Element.paragraph
                    [ Style.fonts.body
                    , Element.Font.color (Element.rgba 0 0 0 1)
                    , Style.fonts.body
                    , Style.fontSize.medium
                    , Element.spacing 12
                    ]
                    [ Element.text content |> Element.el [] ]
                , author
                ]
            ]


quoteColor =
    Style.palette.light

module Page.CaseStudies exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
import Url
import Url.Builder
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
            "Case Studies"
        , quote "Dillon at Incremental Elm has been crucial in guiding our transition to Elm. His approach is focused on your goals, with Elm as a tool to get you there. With his coaching we got Elm up and running and shipped an entirely new product, and with exceptional speed and quality - something that has previously been a myth with highly interactive frontends. If you have the chance to work with Incremental Elm, take it."
        ]


quoteColor =
    Style.palette.light


quote content =
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
                , Style.fontSize.body
                ]
                [ Element.text content |> Element.el [] ]
            , Element.row [ Element.Font.bold ]
                [ Element.text "Ed Gonzalez, Co-Founder at "
                , Style.Helpers.link { url = "https://buildrtech.com/", content = "Buildr Technologies" }
                ]
            ]
        ]



-- , quotationMark "”"


paragraph styles content =
    [ Element.text content ]
        |> Element.paragraph ([ Element.width Element.fill ] ++ styles)

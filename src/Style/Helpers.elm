module Style.Helpers exposing (blockQuote, button, fontAwesomeLink, link, link2, roundedAvatar, sameTabLink, sameTabLink2, smallTitle, title)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes as Attr
import Style
import View.FontAwesome as FontAwesome


button { fontColor, backgroundColor, size } children =
    Element.row
        [ Element.spacing 20
        , Element.Font.color (fontColor Style.palette)
        , Element.mouseOver
            [ Background.color (backgroundColor Style.hoverPalette)
            ]
        , Background.color (backgroundColor Style.palette)
        , Element.padding 15
        , Element.Border.rounded 10
        , Style.fontSize.body
        , size
        ]
        children


title contents =
    Element.paragraph
        [ Style.fontSize.title
        , Style.fonts.title
        , Element.Font.center
        , Element.width Element.fill
        ]
        [ contents ]


smallTitle contents =
    Element.paragraph
        [ Style.fontSize.smallTitle
        , Style.fonts.title
        , Element.Font.center
        , Element.width Element.fill
        ]
        [ contents ]


link2 { url, content } =
    Element.newTabLink
        []
        { url = url
        , label =
            Element.row
                [ Element.Font.color
                    (Element.rgb255 17 132 206)
                , Element.mouseOver
                    [ Element.Font.color (Element.rgb255 234 21 122)
                    ]
                , Element.htmlAttribute (Attr.style "display" "inline-flex")
                ]
                [ content ]
        }


link { url, content } =
    Element.newTabLink
        []
        { url = url
        , label =
            Element.row
                [ Element.Font.color
                    (Element.rgb255 17 132 206)
                , Element.mouseOver
                    [ Element.Font.color (Element.rgb255 234 21 122)
                    ]
                , Element.htmlAttribute (Attr.style "display" "inline-flex")
                ]
                [ Element.text content ]
        }


fontAwesomeLink { url, name } =
    Element.newTabLink
        []
        { url = url
        , label =
            Element.row
                [ Element.mouseOver
                    [ Element.Font.color (Element.rgb255 234 21 122)
                    ]
                ]
                [ FontAwesome.styledIcon name [] ]
        }



--Element.newTabLink [ Element.Font.color Style.palette.highlight ]
--    { url = url, label = Element.text content }


sameTabLink { url, content } =
    Element.link [ Element.Font.color Style.palette.highlight ]
        { url = url, label = Element.text content }


sameTabLink2 { url, content } =
    Element.link [ Element.width Element.fill ]
        { url = url, label = content }


blockQuote :
    Dimensions
    -> { content : String, author : Element msg }
    -> Element msg
blockQuote dimensions { content, author } =
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


roundedAvatar src =
    Html.img
        [ Attr.src src
        , Attr.style "border-radius" "50%"
        , Attr.style "max-width" "75px"
        ]
        []
        |> Element.html
        |> Element.el []

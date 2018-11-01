module Style.Helpers exposing (button, link)

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

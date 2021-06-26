module Style exposing (animationPalette, color, fontSize, fonts, hoverPalette, palette, shadow)

import Animation
import Element
import Element.Border
import Element.Font


fonts : { title : Element.Attribute msg, body : Element.Attribute a, code : Element.Attribute b }
fonts =
    { title = Element.Font.family [ Element.Font.typeface "Open Sans" ]
    , body = Element.Font.family [ Element.Font.typeface "Raleway" ]
    , code = Element.Font.family [ Element.Font.typeface "Roboto Mono" ]
    }


fontSize : { body : Element.Attr decorative msg, title : Element.Attr a b, smallTitle : Element.Attr c d, quotation : Element.Attr e f, medium : Element.Attr g h, small : Element.Attr i j, logo : Element.Attr k l }
fontSize =
    { body = Element.Font.size 18
    , title = Element.Font.size 40
    , smallTitle = Element.Font.size 30
    , quotation = Element.Font.size 100
    , medium = Element.Font.size 16
    , small = Element.Font.size 14
    , logo = Element.Font.size 24
    }


color : { main : Element.Color, bold : Element.Color, light : Element.Color, darkGray : Element.Color, highlight : Element.Color, mainBackground : Element.Color, highlightBackground : Element.Color }
color =
    palette


shadow : Element.Attr decorative msg
shadow =
    Element.Border.shadow { offset = ( 2, 1 ), size = 1, blur = 4, color = Element.rgb 0.8 0.8 0.8 }


palette :
    { main : Element.Color
    , bold : Element.Color
    , light : Element.Color
    , darkGray : Element.Color
    , highlight : Element.Color
    , mainBackground : Element.Color
    , highlightBackground : Element.Color
    }
palette =
    { main = elementRgb 216 219 226
    , bold = elementRgb 0 23 31
    , light = elementRgb 0 126 167
    , darkGray = elementRgb 116 119 126
    , highlight = elementRgb 0 168 232
    , mainBackground = elementRgb 255 255 255
    , highlightBackground = elementRgb 0 52 89
    }


hoverPalette :
    { main : Element.Color
    , bold : Element.Color
    , darkGray : Element.Color
    , light : Element.Color
    , highlight : Element.Color
    , mainBackground : Element.Color
    , highlightBackground : Element.Color
    }
hoverPalette =
    { main = highlightRgb 216 219 226
    , bold = highlightRgb 0 23 31
    , darkGray = highlightRgb 176 179 186
    , light = highlightRgb 0 126 167
    , highlight = highlightRgb 0 168 232
    , mainBackground = highlightRgb 255 255 255
    , highlightBackground = highlightRgb 0 52 89
    }


highlightFactor : number
highlightFactor =
    25


highlightRgb : Float -> Float -> Float -> Element.Color
highlightRgb red green blue =
    elementRgb (red + highlightFactor) (green + highlightFactor) (blue + highlightFactor)


elementRgb : Float -> Float -> Float -> Element.Color
elementRgb red green blue =
    Element.rgb (red / 255) (green / 255) (blue / 255)


rgb : Int -> Int -> Int -> Animation.Color
rgb red green blue =
    { red = red
    , green = green
    , blue = blue
    , alpha = 1.0
    }


animationPalette :
    { main : Animation.Color
    , bold : Animation.Color
    , light : Animation.Color
    , highlight : Animation.Color
    , mainBackground : Animation.Color
    , highlightBackground : Animation.Color
    }
animationPalette =
    { main = rgb 216 219 226
    , bold = rgb 0 23 31
    , light = rgb 0 126 167
    , highlight = rgb 0 168 232
    , mainBackground = rgb 255 255 255
    , highlightBackground = rgb 0 52 89
    }

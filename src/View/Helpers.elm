module View.Helpers exposing (button, textButton)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font
import Style exposing (fontSize, fonts, palette)


textButton { url, text } additionalStyle =
    button { url = url, label = Element.text text } additionalStyle


button { url, label } additionalStyle =
    { url = url, label = label }
        |> Element.newTabLink
            ([ Background.color palette.highlight
             , Element.padding 12
             , Border.shadow { offset = ( 2, 1 ), size = 1, blur = 4, color = Element.rgb 0.8 0.8 0.8 }
             , Element.Font.color palette.mainBackground
             , Border.rounded 5
             , Element.centerX
             ]
                ++ additionalStyle
            )

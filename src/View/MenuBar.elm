module View.MenuBar exposing (view)

import Animation
import Element
import Element.Background as Background
import Style exposing (fonts, palette)


view model =
    Element.column [ Element.spacing 5, Element.height (Element.px 100), Element.centerX, Element.centerY ]
        [ animatedBar model .upper
        , animatedBar model .middle
        , animatedBar model .lower
        ]


animatedBar model getTupleItem =
    Element.el
        ([ 22 |> Element.px |> Element.width
         , 2 |> Element.px |> Element.height
         , Background.color palette.bold
         ]
            ++ (model.menuBarAnimation
                    |> getTupleItem
                    |> Animation.render
                    |> List.map Element.htmlAttribute
               )
        )
        Element.none

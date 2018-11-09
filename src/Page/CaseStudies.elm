module Page.CaseStudies exposing (view)

import Dimensions exposing (Dimensions)
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


view : Dimensions -> Element.Element msg
view dimensions =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.padding
            (if Dimensions.isMobile dimensions then
                20

             else
                50
            )
        , Element.spacing 30
        , Element.width (Element.fill |> Element.maximum 900)
        , Element.centerX
        ]
        [ Element.paragraph
            [ Style.fontSize.title
            , Style.fonts.title
            , Element.Font.center
            , Element.width Element.fill
            ]
            [ Element.text "Case Studies" ]
        , Style.Helpers.blockQuote
            dimensions
            { content = "Dillon at Incremental Elm has been crucial in guiding our transition to Elm. His approach is focused on your goals, with Elm as a tool to get you there. With his coaching we got Elm up and running and shipped an entirely new product, and with exceptional speed and quality - something that has previously been a myth with highly interactive frontends. If you have the chance to work with Incremental Elm, take it."
            , author =
                Element.paragraph [ Element.Font.bold ]
                    [ Element.text "Ed Gonzalez, Co-Founder at "
                    , Style.Helpers.link { url = "https://buildrtech.com/", content = "Buildr Technologies" }
                    ]
            }
        ]

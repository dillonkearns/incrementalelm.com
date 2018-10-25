module Page.Intros exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
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
        ]
        [ [ Element.text "Free Intro Talk" ]
            |> Element.paragraph
                [ Style.fontSize.title
                , Style.fonts.title
                , Element.Font.center
                , Element.width Element.fill
                ]
        , introInfo "Adaptable, Reliable Frontends With Elm" "Experience what it's like to make changes and do refactorings in a non-trivial Elm code base. You'll learn about some libraries that make Elm even more robust, like Elm UI, dillonkearns/elm-graphql, elm-typescript-interop, and remote-data." dimensions
        , introInfo "How I Introduced Elm at a Fortune 10" "Learn about the conditions that made Elm the right choice for a frontend framework at a Fortune 10 company, and how we pitched it to management. You'll understand some of the reasons why the teams moved faster with fewer bugs after only a few weeks' experience with Elm. We'll wrap up with a live code demo showing how to get started introducing your first bit of Elm to a JavaScript codebase." dimensions
        ]


introInfo title body dimensions =
    Element.row
        [ Element.Border.shadow { offset = ( 2, 1 ), size = 1, blur = 4, color = Element.rgb 0.8 0.8 0.8 }
        , Element.centerX
        , Element.width (Element.fill |> Element.maximum 900)
        ]
        [ Element.column
            [ Element.spacing 25
            , Element.centerX
            , Element.padding 30
            , Element.width Element.fill
            ]
            [ Element.paragraph
                [ fontSize.title
                , Element.Font.size 32
                , Element.Font.center
                ]
                [ Element.text title ]
            , bioView body
            ]
        ]


bioView body =
    Element.paragraph
        [ Element.Font.size 16
        , Style.fonts.body
        , Element.width Element.fill
        ]
        [ Element.text body ]

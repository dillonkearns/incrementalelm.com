module Page.Learn exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
import View.Ellie
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
                30

             else
                200
            )
        , Element.spacing 30
        ]
        [ [ Element.text "The Elm Architecture" ]
            |> Element.paragraph
                [ Style.fontSize.title
                , Style.fonts.title
                , Element.Font.center
                , Element.width Element.fill
                ]
        , image
        , View.Ellie.view "3xfc59cYsd6a1"
        , authorResources dimensions
        ]


authorResources dimensions =
    Element.column [ Element.spacing 8, Element.centerX ]
        [ resource "Architecture section of The Official Elm Guide" "https://guide.elm-lang.org/architecture/" Article
        ]


type Resource
    = Library
    | Video
    | App
    | Article


resource resourceName url resourceType =
    let
        ( iconClasses, color, font ) =
            case resourceType of
                Library ->
                    ( "fa fa-code", palette.highlight, Style.fonts.code )

                Video ->
                    ( "fab fa-youtube", Element.rgb255 255 0 0, Style.fonts.title )

                App ->
                    ( "fas fa-desktop", Element.rgb255 0 122 255, Style.fonts.title )

                Article ->
                    ( "far fa-newspaper", Element.rgb255 0 122 255, Style.fonts.title )
    in
    Element.newTabLink [ Element.width Element.fill ]
        { label =
            Element.row [ Element.spacing 5 ]
                [ View.FontAwesome.styledIcon iconClasses [ Element.Font.color color ]
                , [ Element.text resourceName ] |> Element.paragraph [ font ]
                ]
        , url = url
        }


image =
    Element.image [ Element.width (Element.fill |> Element.maximum 600), Element.centerX ]
        { src = "/assets/architecture.jpg"
        , description = "The Elm Architecture"
        }

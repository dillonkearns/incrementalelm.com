module View.Resource exposing (Resource, ResourceKind(..), view)

import Element exposing (Element)
import Element.Font
import Style exposing (palette)
import View.FontAwesome


type alias Resource =
    { name : String
    , url : String
    , kind : ResourceKind
    , description : Maybe String
    }


type ResourceKind
    = Library
    | Video
    | App
    | Article
    | Exercise
    | Book


view { name, url, kind } =
    let
        ( iconClasses, color, font ) =
            case kind of
                Library ->
                    ( "fa fa-code", palette.highlight, Style.fonts.code )

                Video ->
                    ( "fab fa-youtube", Element.rgb255 255 0 0, Style.fonts.title )

                App ->
                    ( "fas fa-desktop", Element.rgb255 0 122 255, Style.fonts.title )

                Article ->
                    ( "far fa-newspaper", Element.rgb255 0 122 255, Style.fonts.title )

                Exercise ->
                    ( "fas fa-pencil-alt", Element.rgb255 0 122 255, Style.fonts.title )

                Book ->
                    ( "fas fa-book", Element.rgb255 0 122 255, Style.fonts.title )
    in
    Element.newTabLink [ Element.width Element.fill ]
        { label =
            Element.row [ Style.fontSize.body, Element.spacing 5, Element.Font.center, Element.centerX ]
                [ View.FontAwesome.styledIcon iconClasses [ Element.Font.color color ]
                , [ Element.text name ] |> Element.paragraph [ font ]
                ]
        , url = url
        }

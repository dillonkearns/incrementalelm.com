module View.Resource exposing (ResourceKind(..), view)

import Element
import Element.Font
import Style exposing (palette)
import View.FontAwesome


type ResourceKind
    = Library
    | Video
    | App
    | Article
    | Exercise
    | Book


view : { a | name : String, url : String, kind : ResourceKind } -> Element.Element msg
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

module View.Page exposing (parseMarkup, view)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import MarkParser


type alias Page =
    { title : String
    , body : String
    , url : String
    }


view : Page -> Dimensions -> Element msg
view page dimensions =
    page.body
        |> parseMarkup
        |> Element.el
            [ if Dimensions.isMobile dimensions then
                Element.width (Element.fill |> Element.maximum 600)

              else
                Element.width Element.fill
            , Element.height Element.fill
            , if Dimensions.isMobile dimensions then
                Element.padding 20

              else
                Element.paddingXY 200 50
            , Element.spacing 30
            ]


parseMarkup : String -> Element msg
parseMarkup markup =
    markup
        |> MarkParser.parse []
        |> (\result ->
                case result of
                    Err message ->
                        Element.text "Couldn't parse!\n"

                    Ok element ->
                        element identity
           )

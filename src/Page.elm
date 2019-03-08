module Page exposing (Page, all, view)

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
        |> MarkParser.parse
        |> (\result ->
                case result of
                    Err message ->
                        Element.text "Couldn't parse!\n"

                    Ok element ->
                        element identity
           )


all =
    [ { title = "Elm GraphQL Workshop"
      , body = """| Image
    description = Elm-GraphQL Full-Day Workshop
    src = /assets/elm-graphql-workshop-header.jpg

This workshop will equip you with everything you need to make guaranteed-correct, type-safe API requests from your Elm code! And all without needing to write a single JSON Decoder by hand!

In this hands-on workshop, the author of Elm's type-safe GraphQL query builder library, {Link|dillonkearns\\/elm-graphql|url=https://github.com/dillonkearns/elm-graphql}, will walk you through the core concepts and best practices of the library. Check out {Link|Types Without Borders|url=https://www.youtube.com/watch?v=memIRXFSNkU} from the most recent Elm Conf for some of the underlying philosophy of this library. Or you can {Link|read an overview of features of this library|url=https://medium.com/open-graphql/type-safe-composable-graphql-in-elm-b3378cc8d021}. Check out some highlights at the bottom of this event description."""
      , url = "elm-graphql-workshop"
      }
    ]

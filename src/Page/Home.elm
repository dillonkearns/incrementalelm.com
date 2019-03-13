module Page.Home exposing (view)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import MarkParser
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
import View.FontAwesome


view : Dimensions -> List (Element.Element msg)
view dimensions =
    [ parsedMarkup dimensions ]


parsedMarkup : Dimensions -> Element msg
parsedMarkup dimensions =
    """| Header
    Stop Learning Elm Best Practices */The Hard Way/*

We've been down this path so you don't have to. And we have the proven training material and coding techniques to put your team on the fast track to writing code like Elm Experts.

Here's a blog post that will teach you one of my techniques {Link|writing Elm quickly and without getting stuck|url = https://medium.com/@dillonkearns/moving-faster-with-tiny-steps-in-elm-2e6a269e4efc} by taking tiny steps.

Learn more about how our Elm Developer Support Packages can save your team time and help you deliver on Elm's promise of insanely reliable, easy to maintain applications.

Or check out my free Incremental Elm Tips to learn the tricks that Elm Masters use intuitively to speed through building up Elm code with ease.

Learn more about the services I provide to help your team write Elm faster and more reliably.

Give your team lead a break from researching "the best way to do X in Elm", and preparing learning sessions on the basics for the rest of the team. That's what we're here for! We can get your team "thinking in Elm" with our tested teaching techniques and expert guidance.


"""
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

module Route exposing (Route(..), parse, title)

import Url.Builder
import Url.Parser exposing ((</>), Parser, s)
import View.MenuBar
import View.Navbar


type Route
    = Home
    | Coaches
    | Learn String
    | Intros


title : Maybe Route -> String
title maybeRoute =
    maybeRoute
        |> Maybe.map
            (\route ->
                case route of
                    Home ->
                        "Incremental Elm Consulting"

                    Coaches ->
                        "Incremental Elm Coaches"

                    Intros ->
                        "Free Intro Talk"

                    Learn learnTitle ->
                        learnTitle
            )
        |> Maybe.withDefault "Incremental Elm - Page not found"


parse url =
    url
        |> Url.Parser.parse parser


parser : Url.Parser.Parser (Route -> a) a
parser =
    Url.Parser.oneOf
        [ Url.Parser.map Home Url.Parser.top
        , Url.Parser.map Intros (s "intro")
        , Url.Parser.map Coaches (s "coaches")
        , Url.Parser.map (Learn "architecture") (s "learn" </> s "architecture")
        ]

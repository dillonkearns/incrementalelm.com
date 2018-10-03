module Route exposing (Route(..), parse, title)

import Url.Builder
import Url.Parser exposing (Parser)
import View.MenuBar
import View.Navbar


type Route
    = Home
    | WhyElm
    | Coaches
    | NotFound


title : Route -> String
title route =
    case route of
        Home ->
            "Incremental Elm Consulting"

        WhyElm ->
            "Incremental Elm - Why Elm?"

        Coaches ->
            "Incremental Elm Coaches"

        NotFound ->
            "Incremental Elm Consulting"


parse url =
    url
        |> Url.Parser.parse parser
        |> Maybe.withDefault NotFound


parser : Url.Parser.Parser (Route -> a) a
parser =
    Url.Parser.oneOf
        [ Url.Parser.map Home Url.Parser.top
        , Url.Parser.map WhyElm (Url.Parser.s "why-elm")
        , Url.Parser.map Coaches (Url.Parser.s "coaches")
        ]

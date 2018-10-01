module Route exposing (Route(..), parse)

import Url.Builder
import Url.Parser exposing (Parser)
import View.MenuBar
import View.Navbar


type Route
    = Home
    | WhyElm
    | NotFound


parse url =
    url
        |> Url.Parser.parse parser
        |> Maybe.withDefault NotFound


parser : Url.Parser.Parser (Route -> a) a
parser =
    Url.Parser.oneOf
        [ Url.Parser.map Home Url.Parser.top
        , Url.Parser.map WhyElm (Url.Parser.s "why-elm")
        ]

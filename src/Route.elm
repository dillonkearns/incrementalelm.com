module Route exposing (Route(..), parse, title, toUrl)

import Url.Builder
import Url.Parser exposing ((</>), Parser, s)
import View.MenuBar


type Route
    = Home
    | Coaches
    | Learn (Maybe String)
    | Intros
    | CaseStudies


toUrl route =
    (case route of
        Home ->
            []

        Coaches ->
            [ "coaches" ]

        Intros ->
            [ "intro" ]

        Learn maybeLearnTitle ->
            case maybeLearnTitle of
                Just learnTitle ->
                    [ "learn", learnTitle ]

                Nothing ->
                    [ "learn" ]

        CaseStudies ->
            [ "case-studies" ]
    )
        |> (\path -> Url.Builder.absolute path [])


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

                    Learn maybeLearnTitle ->
                        case maybeLearnTitle of
                            Just learnTitle ->
                                learnTitle

                            Nothing ->
                                "Incremental Elm Learning Resources"

                    CaseStudies ->
                        "Incremental Elm Case Studies"
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
        , Url.Parser.map CaseStudies (s "case-studies")
        , Url.Parser.map (Learn (Just "architecture")) (s "learn" </> s "architecture")
        , Url.Parser.map (Learn Nothing) (s "learn")
        ]

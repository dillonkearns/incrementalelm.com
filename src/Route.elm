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
    | Contact
    | Signup { maybeReferenceId : Maybe String }


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

        Contact ->
            [ "contact" ]

        Signup _ ->
            [ "signup" ]
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

                    Contact ->
                        "Contact Incremental Elm"

                    Signup _ ->
                        "Incremental Elm - Signup"
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
        , Url.Parser.map Contact (s "contact")
        , Url.Parser.map CaseStudies (s "case-studies")
        , Url.Parser.map (\learnPostName -> Learn (Just learnPostName)) (s "learn" </> Url.Parser.string)
        , Url.Parser.map (Learn Nothing) (s "learn")
        , Url.Parser.map (Signup { maybeReferenceId = Nothing }) (s "signup")
        , Url.Parser.map (\signupPath -> Signup { maybeReferenceId = Nothing }) (s "signup" </> Url.Parser.string)
        , Url.Parser.map (\signupPath referenceId -> Signup { maybeReferenceId = Just referenceId }) (s "signup" </> Url.Parser.string </> Url.Parser.string)
        ]

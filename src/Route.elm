module Route exposing (Route(..), SignupDetails, parse, title, toUrl)

import Page
import Url exposing (Url)
import Url.Builder
import Url.Parser exposing ((</>), Parser, s)
import View.MenuBar


type Route
    = HomeOld
    | Coaches
    | Events
    | Learn (Maybe String)
    | Article (Maybe String)
    | Intros
    | CaseStudies
    | Signup SignupDetails
    | Feedback
    | CustomPage Page.Page


type alias SignupDetails =
    { maybeReferenceId : Maybe String, formName : Maybe String }


toUrl : Route -> String
toUrl route =
    (case route of
        HomeOld ->
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

        Article maybePostTitle ->
            case maybePostTitle of
                Just postTitle ->
                    [ "articles", postTitle ]

                Nothing ->
                    [ "articles" ]

        CaseStudies ->
            [ "case-studies" ]

        Signup _ ->
            [ "signup" ]

        Feedback ->
            [ "feedback" ]

        Events ->
            [ "events" ]

        CustomPage page ->
            [ page.url ]
    )
        |> (\path -> Url.Builder.absolute path [])


title : Maybe Route -> String
title maybeRoute =
    maybeRoute
        |> Maybe.map
            (\route ->
                case route of
                    HomeOld ->
                        "Incremental Elm Training"

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

                    Article maybePostTitle ->
                        case maybePostTitle of
                            Just postTitle ->
                                postTitle

                            Nothing ->
                                "Incremental Elm - Articles"

                    CaseStudies ->
                        "Incremental Elm Case Studies"

                    Signup _ ->
                        "Incremental Elm - Signup"

                    Feedback ->
                        "Incremental Elm Workshop Feedback"

                    Events ->
                        "Incremental Elm - Event Calendar"

                    CustomPage page ->
                        page.title
            )
        |> Maybe.withDefault "Incremental Elm - Page not found"


parse : Url -> Maybe Route
parse url =
    url
        |> Url.Parser.parse parser


parser : Url.Parser.Parser (Route -> a) a
parser =
    Url.Parser.oneOf
        [ Url.Parser.map Intros (s "intro")
        , Url.Parser.map Events (s "events")
        , Url.Parser.map Feedback (s "feedback")
        , Url.Parser.map Coaches (s "coaches")
        , Url.Parser.map CaseStudies (s "case-studies")
        , Url.Parser.map (\postName -> Learn (Just postName)) (s "learn" </> Url.Parser.string)
        , Url.Parser.map (Learn Nothing) (s "learn")
        , Url.Parser.map (\postName -> Article (Just postName)) (s "articles" </> Url.Parser.string)
        , Url.Parser.map (Article Nothing) (s "articles")
        , Url.Parser.map (Signup { maybeReferenceId = Nothing, formName = Nothing }) (s "signup")
        , Url.Parser.map (\signupPath -> Signup { maybeReferenceId = Nothing, formName = Just signupPath }) (s "signup" </> Url.Parser.string)
        , Url.Parser.map (\signupPath referenceId -> Signup { maybeReferenceId = Just referenceId, formName = Just signupPath }) (s "signup" </> Url.Parser.string </> Url.Parser.string)
        , customParser
        ]


customParser : Url.Parser.Parser (Route -> a) a
customParser =
    Page.all
        |> List.map
            (\page ->
                if page.url == "" then
                    Url.Parser.map (CustomPage page) Url.Parser.top

                else
                    Url.Parser.map (CustomPage page) (s page.url)
            )
        |> Url.Parser.oneOf

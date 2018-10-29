module Page.Intros exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
import Url
import Url.Builder
import View.FontAwesome


view :
    { width : Float
    , height : Float
    , device : Element.Device
    }
    -> Element.Element msg
view dimensions =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.padding
            (if dimensions.width <= 1000 then
                20

             else
                50
            )
        , Element.spacing 30
        , Element.width (Element.fill |> Element.maximum 900)
        , Element.centerX
        ]
        [ paragraph
            [ Style.fontSize.title
            , Style.fonts.title
            , Element.Font.center
            , Element.width Element.fill
            ]
            "Free Intro Talk"
        , Element.paragraph
            [ Element.width Element.fill
            , Style.fontSize.body
            , Style.fonts.body
            ]
            [ Element.text "We offer free intro sessions for any teams that are curious to learn more about Elm! This is a great way to gauge whether there is interest in Elm on the team, and whether it might address any relevant pain points. You can "
            , Element.newTabLink [ Element.Font.color palette.highlight ]
                { url = "/coaches", label = Element.text "learn more about our coaches" }
            , Element.text " and their conference talks and open source contributions."
            ]
        , introInfo "https://images.unsplash.com/photo-1521898284481-a5ec348cb555?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6f2ed5bce03f084b61b8936517f711d7&auto=format&fit=crop&w=668&q=80" "Adaptable, Reliable Frontends With Elm" "Experience the remarkable ease of adding features and refactoring in a non-trivial Elm codebase. You'll learn about some libraries that make Elm even more robust, like Elm UI, dillonkearns/elm-graphql, elm-typescript-interop, and remote-data." dimensions
        , introInfo "https://images.unsplash.com/photo-1522165078649-823cf4dbaf46?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=756f069c98c96a701453b1e27630e961&auto=format&fit=crop&w=1650&q=80" "Introducing Elm at a Fortune 10" "Learn about the conditions that made Elm the right choice of frontend framework at a Fortune 10 company, and how we pitched it to management. You'll understand some of the reasons why the teams moved faster with fewer bugs after only a few weeks with Elm. We'll wrap up with a live code demo showing how to get started introducing your first bit of Elm to a JavaScript codebase." dimensions
        ]


paragraph styles content =
    [ Element.text content ]
        |> Element.paragraph ([ Element.width Element.fill ] ++ styles)


introInfo iconUrl title body dimensions =
    Element.row
        [ Element.Border.shadow { offset = ( 2, 1 ), size = 1, blur = 4, color = Element.rgb 0.8 0.8 0.8 }
        , Element.centerX
        ]
        [ Element.column
            [ Element.spacing 25
            , Element.centerX
            , Element.padding 30
            , Element.width Element.fill
            ]
            [ icon iconUrl
            , Element.paragraph
                [ fontSize.title
                , Element.Font.size 32
                , Element.Font.center
                ]
                [ Element.text title ]
            , bioView body
            , requestButton title
            ]
        ]


icon iconUrl =
    Element.image [ Element.width (Element.fill |> Element.maximum 250), Element.centerX ]
        { src = iconUrl
        , description = "Icon"
        }


requestButton talkTitle =
    Element.newTabLink
        [ Element.centerX
        ]
        { url = mailUrl talkTitle
        , label =
            Style.Helpers.button
                { fontColor = .mainBackground
                , backgroundColor = .highlight
                , size = fontSize.body
                }
                [ envelopeIcon |> Element.el []
                , Element.text "Request this talk"
                ]
        }


mailUrl talkTitle =
    "mailto:info@incrementalelm.com"
        ++ Url.Builder.toQuery
            ([ ( "subject"
               , "Request Talk: "
                    ++ talkTitle
               )
             , ( "body"
               , "We are interested in the free " ++ talkTitle ++ " intro talk. Do you have any availability to do a session for our team?"
               )
             ]
                |> List.map (\( key, value ) -> Url.Builder.string key value)
            )


envelopeIcon =
    View.FontAwesome.icon "fas fa-chevron-circle-right"


bioView body =
    Element.paragraph
        [ Element.Font.size 16
        , Style.fonts.body
        , Element.width Element.fill
        ]
        [ Element.text body ]

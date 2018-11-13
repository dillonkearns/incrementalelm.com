module Page.CaseStudies exposing (view)

import Dimensions exposing (Dimensions)
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


view : Dimensions -> Element.Element msg
view dimensions =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.padding
            (if Dimensions.isMobile dimensions then
                20

             else
                50
            )
        , Element.spacing 50
        , Element.width (Element.fill |> Element.maximum 900)
        , Element.centerX
        ]
        [ title "Case Studies"
        , title2 "Getting To Market Fast With Elm"
        , Style.Helpers.blockQuote
            dimensions
            { content = "Dillon at Incremental Elm has been crucial in guiding our transition to Elm. His approach is focused on your goals, with Elm as a tool to get you there. With his coaching we got Elm up and running and shipped an entirely new product, and with exceptional speed and quality - something that has previously been a myth with highly interactive frontends. If you have the chance to work with Incremental Elm, take it."
            , author =
                Element.row [ Element.spacing 20 ]
                    [ Style.Helpers.roundedAvatar "/assets/ed-gonzalez.png"
                    , Element.paragraph [ Element.Font.bold, Element.centerY ]
                        [ Element.text "Ed Gonzalez, Co-Founder at " |> Element.el [ Element.centerY ]
                        , Style.Helpers.link
                            { url = "https://buildrtech.com/"
                            , content = "Buildr Technologies"
                            }
                        ]
                    ]
            }
        , buildrStory dimensions
        ]


title content =
    Element.paragraph
        [ Style.fontSize.title
        , Style.fonts.title
        , Element.Font.center
        , Element.Font.bold
        , Element.width Element.fill
        ]
        [ Element.text content ]


title2 content =
    Element.paragraph
        [ Style.fontSize.smallTitle
        , Style.fonts.title
        , Element.Font.center
        , Element.width Element.fill
        ]
        [ Element.text content ]


buildrStory : Dimensions -> Element msg
buildrStory dimensions =
    Element.column [ Element.spacing 30 ]
        [ "The team at Buildr Tech needed to get their new product, Closeout, ready for showtime within just a couple of months. And once the product was in users' hands, they knew they'd be iterating rapidly to refine it and support their needs with new functionality."
            |> Element.text
            |> paragraph
        , (if Dimensions.isMobile dimensions then
            Element.column [ Element.spacing 30 ]

           else
            Element.row [ Element.spacing 30 ]
          )
            [ groundbreakImage
            , [ Element.text "Mike Stock and Ed Gonzalez came from roles in technical leadership at Procore Technologies, the leading SaaS platform for construction companies. They knew what it took to build a highly interactive, best-in-class user experience like the one they had set out to deliver. But they didn't have the luxury of time. They had heard about the power of Elm's type system to help you deliver faster and fearlessly refactor. They were also excited about "
              , Style.Helpers.link
                    { url = "https://github.com/mdgriffith/elm-ui/"
                    , content = "Elm UI"
                    }
              , Element.text ", a library that makes styling frontends as reliable and easy as the rest of an Elm project."
              ]
                |> Element.paragraph [ Element.spacing 10 ]
            ]
        , [ Element.text "On day 1, we collaborated with Buildr Tech to integrate Elm into their deployment pipeline and move a page from their Closeout app to Elm. We transitioned some API endpoints over to GraphQL and wired up an Elm page using "
          , Style.Helpers.link
                { url = "https://github.com/dillonkearns/elm-graphql"
                , content = "a type-safe Elm GraphQL client"
                }
          , Element.text ". From there, new API requests worked as expected as soon as the code compiled, so Buildr could focus on solving their customers’ problems and getting their new product to market."
          ]
            |> Element.paragraph [ Element.spacing 10 ]
        , "With their app bootstrapped with Elm, they were able to move rapidly building their highly interactive application and go live in time for the big conference! With guidance from Incremental Elm, Buildr was able to lay a solid foundation for their Elm code and grow in a direction that gave them the flexibility they needed to change on a dime."
            |> Element.text
            |> paragraph
        ]


groundbreakImage =
    Element.column
        [ Element.width Element.fill, Element.spacing 20 ]
        [ Element.image
            [ Element.width (Element.fill |> Element.maximum 300)
            , Element.centerX
            ]
            { src = "/assets/buildr-cropped.jpg", description = "Buildr at Groundbreak 2018 launching their Closeout app." }
        , [ Element.text "Buildr at GroundBreak 2018 launching their Closeout app." ]
            |> Element.paragraph [ Style.fontSize.small, Element.Font.center ]
        ]


paragraph content =
    Element.paragraph [ Element.spacing 10 ] [ Element.el [] content ]

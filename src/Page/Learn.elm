module Page.Learn exposing (view)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Page.Learn.Architecture
import Page.Learn.GettingStarted
import Page.Learn.Post exposing (Post)
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
import View.Ellie
import View.FontAwesome
import View.Resource as Resource


view : Dimensions -> String -> Element.Element msg
view dimensions learnPageName =
    Element.column
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
        (findPostByName learnPageName
            |> Maybe.map
                (\learnPost ->
                    title learnPost.title
                        :: learnPost.body dimensions
                )
            |> Maybe.withDefault [ Element.text "Couldn't find page!" ]
        )


all =
    [ Page.Learn.Architecture.details
    , Page.Learn.GettingStarted.details
    ]


findPostByName : String -> Maybe (Post msg)
findPostByName postName =
    all
        |> List.filter (\post -> post.pageName == postName)
        |> List.head


title text =
    [ Element.text text ]
        |> Element.paragraph
            [ Style.fontSize.title
            , Style.fonts.title
            , Element.Font.center
            , Element.width Element.fill
            ]


resourcesView dimensions resources =
    Element.column [ Element.spacing 32, Element.centerX ]
        [ title "Further Reading and Exercises"
        , Element.column [ Element.spacing 16, Element.centerX ]
            (resources |> List.map Resource.view)
        ]


image =
    Element.image [ Element.width (Element.fill |> Element.maximum 600), Element.centerX ]
        { src = "/assets/architecture.jpg"
        , description = "The Elm Architecture"
        }

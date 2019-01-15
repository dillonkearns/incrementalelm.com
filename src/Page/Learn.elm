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


view : Dimensions -> Maybe String -> Element.Element msg
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
        (case learnPageName of
            Just actualLearnPageName ->
                findPostByName actualLearnPageName
                    |> Maybe.map (learnPostView dimensions)
                    |> Maybe.withDefault [ Element.text "Couldn't find page!" ]

            Nothing ->
                resourcesDirectory
        )


learnPostView :
    Dimensions
    -> Post msg
    -> List (Element msg)
learnPostView dimensions learnPost =
    title learnPost.title
        :: (learnPost.body dimensions
                ++ [ learnPost.resources.title
                        |> Maybe.map title
                        |> Maybe.withDefault Element.none
                   , newResourcesView learnPost.resources.items
                   ]
           )


resourcesDirectory =
    all
        |> List.map
            (\resource ->
                Style.Helpers.sameTabLink
                    { url = "/learn/" ++ resource.pageName
                    , content = resource.title
                    }
            )


all : List (Post msg)
all =
    [ Page.Learn.GettingStarted.details
    , Page.Learn.Architecture.details
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


newResourcesView resources =
    Element.column
        [ Element.spacing 16
        , Element.centerX
        , Element.padding 30
        , Element.width Element.fill
        ]
        (resources
            |> List.map
                (\resource ->
                    case resource.description of
                        Nothing ->
                            Resource.view resource

                        Just description ->
                            Element.column
                                [ Element.spacing 8
                                , Element.width Element.fill
                                , Element.paddingXY 0 16
                                ]
                                [ Resource.view resource
                                , Element.paragraph [ Style.fontSize.small, Element.Font.center ] [ Element.text description ]
                                ]
                )
        )


image =
    Element.image [ Element.width (Element.fill |> Element.maximum 600), Element.centerX ]
        { src = "/assets/architecture.jpg"
        , description = "The Elm Architecture"
        }

module Page.Learn exposing (all, view)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Mark
import MarkParser
import Page.Learn.Architecture
import Page.Learn.GettingStarted
import Page.Learn.Post exposing (Post)
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
import View.Ellie
import View.FontAwesome
import View.Resource as Resource exposing (Resource)


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
    -> Post
    -> List (Element msg)
learnPostView dimensions learnPost =
    [ title learnPost.title
    , parsePostBody learnPost.body
    , learnPost.resources.title
        |> Maybe.map title
        |> Maybe.withDefault Element.none
    , newResourcesView learnPost.resources.items
    ]


parsePostBody : String -> Element msg
parsePostBody markup =
    markup
        |> Mark.parse MarkParser.document
        |> (\result ->
                case result of
                    Err message ->
                        Element.text "Couldn't parse!\n"

                    Ok element ->
                        element identity
           )


resourcesDirectory : List (Element msg)
resourcesDirectory =
    all
        |> List.map
            (\resource ->
                Style.Helpers.sameTabLink
                    { url = "/learn/" ++ resource.pageName
                    , content = resource.title
                    }
            )


all : List Post
all =
    [ Page.Learn.GettingStarted.details
    , Page.Learn.Architecture.details
    ]


findPostByName : String -> Maybe Post
findPostByName postName =
    all
        |> List.filter (\post -> post.pageName == postName)
        |> List.head


title : String -> Element msg
title text =
    [ Element.text text ]
        |> Element.paragraph
            [ Style.fontSize.title
            , Style.fonts.title
            , Element.Font.center
            , Element.width Element.fill
            ]


newResourcesView :
    List Resource
    -> Element msg
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

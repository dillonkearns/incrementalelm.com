module LearnIndex exposing (view)

import Element exposing (Element)
import Element.Border
import Element.Font
import Metadata exposing (Metadata)
import Pages.Parser
import Style.Helpers


view :
    List ( List String, Metadata msg )
    -> Element msg
view posts =
    Element.column [ Element.spacing 20 ]
        (posts
            |> List.filterMap
                (\( path, metadata ) ->
                    case metadata of
                        Metadata.Page meta ->
                            Nothing

                        Metadata.Article meta ->
                            Nothing

                        Metadata.Learn meta ->
                            Just ( path, meta )
                )
            |> List.map postSummary
        )


postSummary :
    ( List String, Metadata.LearnMetadata )
    -> Element msg
postSummary ( postPath, post ) =
    learnIndex post
        |> linkToPost postPath


linkToPost : List String -> Element msg -> Element msg
linkToPost postPath content =
    Element.link [ Element.width Element.fill ]
        { url = postUrl postPath, label = content }


postUrl : List String -> String
postUrl postPath =
    "/"
        ++ String.join "/" postPath


title : String -> Element msg
title text =
    [ Element.text text ]
        |> Element.paragraph
            [ Element.Font.size 36
            , Element.Font.center
            , Element.Font.family [ Element.Font.typeface "Raleway" ]
            , Element.Font.semiBold
            , Element.padding 16
            ]


learnIndex : Metadata.LearnMetadata -> Element msg
learnIndex metadata =
    Element.el
        [ Element.centerX
        , Element.width (Element.maximum 800 Element.fill)
        , Element.padding 40
        , Element.spacing 10
        , Element.Border.width 1
        , Element.Border.color (Element.rgba255 0 0 0 0.1)
        , Element.mouseOver
            [ Element.Border.color (Element.rgba255 0 0 0 1)
            ]
        ]
        (postPreview metadata)


readMoreLink =
    Element.text "Continue reading >>"
        |> Element.el
            [ Element.centerX
            , Element.Font.size 18
            , Element.alpha 0.6
            , Element.mouseOver [ Element.alpha 1 ]
            , Element.Font.underline
            , Element.Font.center
            ]


postPreview : Metadata.LearnMetadata -> Element msg
postPreview post =
    Element.textColumn
        [ Element.centerX
        , Element.width Element.fill
        , Element.spacing 30
        , Element.Font.size 18
        ]
        [ title post.title

        -- , post.description.styled
        --     |> Element.paragraph
        --         [ Element.Font.size 22
        --         , Element.Font.center
        --         , Element.Font.family [ Element.Font.typeface "Raleway" ]
        --         ]
        , readMoreLink
        ]


image article =
    Element.image
        [ Element.width (Element.fill |> Element.maximum 600)
        , Element.centerX
        ]
        { src = article.coverImage
        , description = article.title.raw ++ " cover image"
        }
        |> Element.el [ Element.centerX ]

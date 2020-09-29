module Index exposing (view)

import Element exposing (Element)
import Element.Border
import Element.Font
import Metadata exposing (Metadata)
import Pages
import Pages.ImagePath as ImagePath
import Pages.PagePath as PagePath exposing (PagePath)
import Style.Helpers


view :
    List ( PagePath Pages.PathKey, Metadata msg )
    -> Element msg
view posts =
    Element.column [ Element.spacing 20 ]
        ((posts
            |> List.filterMap
                (\( path, metadata ) ->
                    case metadata of
                        Metadata.Article meta ->
                            Just ( path, meta )

                        _ ->
                            Nothing
                )
         )
            |> List.map postSummary
        )


postSummary :
    ( PagePath Pages.PathKey, Metadata.ArticleMetadata msg )
    -> Element msg
postSummary ( postPath, post ) =
    articleIndex post
        |> linkToPost postPath


linkToPost : PagePath Pages.PathKey -> Element msg -> Element msg
linkToPost postPath content =
    Element.link [ Element.width Element.fill ]
        { url = PagePath.toString postPath, label = content }


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


articleIndex : Metadata.ArticleMetadata msg -> Element msg
articleIndex metadata =
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


postPreview : Metadata.ArticleMetadata msg -> Element msg
postPreview post =
    Element.textColumn
        [ Element.centerX
        , Element.width Element.fill
        , Element.spacing 30
        , Element.Font.size 18
        ]
        [ title post.title.raw
        , image post
        , post.description.styled
            |> Element.paragraph
                [ Element.Font.size 22
                , Element.Font.center
                , Element.Font.family [ Element.Font.typeface "Raleway" ]
                ]
        , readMoreLink
        ]


image article =
    Element.image
        [ Element.width (Element.fill |> Element.maximum 600)
        , Element.centerX
        ]
        { src = ImagePath.toString article.coverImage
        , description = article.title.raw ++ " cover image"
        }
        |> Element.el [ Element.centerX ]

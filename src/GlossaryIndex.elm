module GlossaryIndex exposing (view)

import Element exposing (Element)
import Element.Border
import Element.Font
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import TemplateType exposing (TemplateType)


view :
    List ( PagePath Pages.PathKey, TemplateType )
    -> Element msg
view posts =
    Element.column [ Element.spacing 20 ]
        (posts
            |> List.filterMap
                (\( path, metadata ) ->
                    case metadata of
                        TemplateType.Glossary meta ->
                            Just ( path, meta )

                        _ ->
                            Nothing
                )
            |> List.map postSummary
        )


postSummary :
    ( PagePath Pages.PathKey, TemplateType.GlossaryMetadata )
    -> Element msg
postSummary ( postPath, post ) =
    learnIndex post
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


learnIndex : TemplateType.GlossaryMetadata -> Element msg
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


postPreview : TemplateType.GlossaryMetadata -> Element msg
postPreview post =
    Element.textColumn
        [ Element.centerX
        , Element.width Element.fill
        , Element.spacing 30
        , Element.Font.size 18
        ]
        [ title post.title
        , Element.paragraph [] [ Element.text post.description ]
        , readMoreLink
        ]

module Index exposing (view)

import Element exposing (Element)
import Element.Border
import Element.Font
import MarkupPages.Parser exposing (PageOrPost)
import Metadata exposing (Metadata)
import Style.Helpers


view :
    List ( List String, PageOrPost (Metadata msg) (Element msg) )
    -> Element msg
view posts =
    Element.column [ Element.spacing 20 ]
        (posts
            |> List.map postSummary
        )


postSummary :
    ( List String, PageOrPost (Metadata msg) (Element msg) )
    -> Element msg
postSummary ( postPath, post ) =
    articleIndex post
        |> linkToPost postPath


linkToPost : List String -> Element msg -> Element msg
linkToPost postPath content =
    Element.link []
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


articleIndex : PageOrPost (Metadata msg) (Element msg) -> Element msg
articleIndex resource =
    Element.column
        [ Element.centerX
        , Element.width (Element.maximum 800 Element.fill)
        , Element.centerX
        , Element.padding 40
        , Element.spacing 10
        , Element.Border.width 1
        , Element.Border.color (Element.rgba255 0 0 0 0.1)
        , Element.mouseOver
            [ Element.Border.color (Element.rgba255 0 0 0 1)
            ]
        ]
        [ title resource.metadata.title.raw
        , Element.column [ Element.spacing 20 ]
            [ resource |> postPreview
            , readMoreLink
            ]
        ]


readMoreLink =
    Element.text "Continue reading >>"
        |> Element.el
            [ Element.centerX
            , Element.Font.size 18
            , Element.alpha 0.6
            , Element.mouseOver [ Element.alpha 1 ]
            , Element.Font.underline
            ]


postPreview : PageOrPost (Metadata msg) (Element msg) -> Element msg
postPreview post =
    Element.textColumn
        [ Element.centerX
        , Element.width Element.fill
        , Element.spacing 30
        , Element.Font.size 18
        ]
        (post.view |> List.take 2)

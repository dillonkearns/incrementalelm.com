module MarkdownToHtmlStringRenderer exposing (renderMarkdown)

import Html.String as Html exposing (Html)
import Html.String.Attributes as Attr
import Markdown.Block as Block
import Markdown.Html
import Markdown.Parser as Markdown
import Markdown.Renderer
import Site


render renderer markdown =
    markdown
        |> Markdown.parse
        |> Result.mapError deadEndsToString
        |> Result.andThen (\ast -> Markdown.Renderer.render renderer ast)


deadEndsToString deadEnds =
    deadEnds
        |> List.map Markdown.deadEndToString
        |> String.join "\n"


renderMarkdown : String -> Result String String
renderMarkdown markdown =
    markdown
        |> render
            { heading =
                \{ level, children } ->
                    case level of
                        Block.H1 ->
                            Html.h1 [] children

                        Block.H2 ->
                            Html.h2 [] children

                        Block.H3 ->
                            Html.h3 [] children

                        Block.H4 ->
                            Html.h4 [] children

                        Block.H5 ->
                            Html.h5 [] children

                        Block.H6 ->
                            Html.h6 [] children
            , paragraph = Html.p []
            , hardLineBreak = Html.br [] []
            , blockQuote = Html.blockquote []
            , strong =
                \children -> Html.strong [] children
            , emphasis =
                \children -> Html.em [] children
            , codeSpan =
                \content -> Html.code [] [ Html.text content ]
            , link =
                \link content ->
                    let
                        fullUrl =
                            if link.destination |> String.startsWith "/" then
                                Site.canonicalUrl ++ link.destination

                            else
                                link.destination
                    in
                    case link.title of
                        Just title ->
                            Html.a
                                [ Attr.href fullUrl
                                , Attr.title title
                                ]
                                content

                        Nothing ->
                            Html.a [ Attr.href fullUrl ] content
            , image =
                \imageInfo ->
                    case imageInfo.title of
                        Just title ->
                            Html.img
                                [ Attr.src imageInfo.src
                                , Attr.alt imageInfo.alt
                                , Attr.title title
                                ]
                                []

                        Nothing ->
                            Html.img
                                [ Attr.src imageInfo.src
                                , Attr.alt imageInfo.alt
                                ]
                                []
            , text =
                Html.text
            , unorderedList =
                \items ->
                    Html.ul []
                        (items
                            |> List.map
                                (\item ->
                                    case item of
                                        Block.ListItem task children ->
                                            let
                                                checkbox =
                                                    case task of
                                                        Block.NoTask ->
                                                            Html.text ""

                                                        Block.IncompleteTask ->
                                                            Html.input
                                                                [ Attr.disabled True
                                                                , Attr.checked False
                                                                , Attr.type_ "checkbox"
                                                                ]
                                                                []

                                                        Block.CompletedTask ->
                                                            Html.input
                                                                [ Attr.disabled True
                                                                , Attr.checked True
                                                                , Attr.type_ "checkbox"
                                                                ]
                                                                []
                                            in
                                            Html.li [] (checkbox :: children)
                                )
                        )
            , orderedList =
                \startingIndex items ->
                    Html.ol
                        (if startingIndex /= 1 then
                            [ Attr.start startingIndex ]

                         else
                            []
                        )
                        (items
                            |> List.map
                                (\itemBlocks ->
                                    Html.li []
                                        itemBlocks
                                )
                        )
            , html =
                Markdown.Html.oneOf []
            , codeBlock =
                \{ body, language } ->
                    Html.pre []
                        [ Html.code []
                            [ Html.text body
                            ]
                        ]
            , thematicBreak = Html.hr [] []
            , table = Html.table []
            , tableHeader = Html.thead []
            , tableBody = Html.tbody []
            , tableRow = Html.tr []
            , tableHeaderCell =
                \maybeAlignment ->
                    let
                        attrs =
                            maybeAlignment
                                |> Maybe.map
                                    (\alignment ->
                                        case alignment of
                                            Block.AlignLeft ->
                                                "left"

                                            Block.AlignCenter ->
                                                "center"

                                            Block.AlignRight ->
                                                "right"
                                    )
                                |> Maybe.map Attr.align
                                |> Maybe.map List.singleton
                                |> Maybe.withDefault []
                    in
                    Html.th attrs
            , tableCell =
                \maybeAlignment ->
                    let
                        attrs =
                            maybeAlignment
                                |> Maybe.map
                                    (\alignment ->
                                        case alignment of
                                            Block.AlignLeft ->
                                                "left"

                                            Block.AlignCenter ->
                                                "center"

                                            Block.AlignRight ->
                                                "right"
                                    )
                                |> Maybe.map Attr.align
                                |> Maybe.map List.singleton
                                |> Maybe.withDefault []
                    in
                    Html.td attrs
            }
        |> Result.map (List.map (Html.toString 0))
        |> Result.map (String.join "")

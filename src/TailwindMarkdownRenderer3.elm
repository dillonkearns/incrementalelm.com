module TailwindMarkdownRenderer3 exposing (..)

import Css
import DataSource exposing (DataSource)
import DataSource.Port
import Html.Attributes
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr exposing (css)
import Json.Encode
import Markdown.Block as Block
import Markdown.Html
import Markdown.Renderer
import Markdown.Scaffolded as Scaffolded exposing (..)
import OptimizedDecoder as Decode
import Shiki
import Tailwind.Utilities as Tw


renderer : Markdown.Renderer.Renderer (Html msg)
renderer =
    Scaffolded.toRenderer
        { renderHtml = Markdown.Html.oneOf []
        , renderMarkdown = reduceHtmlDataSource
        }


reduceHtmlDataSource : Block (Html msg) -> Html msg
reduceHtmlDataSource block =
    case block of
        Scaffolded.Paragraph children ->
            Html.p
                [ css
                    [ Tw.bg_background
                    , Tw.text_foreground
                    , Tw.mb_5
                    ]
                ]
                children

        Scaffolded.Heading { rawText, level, children } ->
            case level of
                Block.H1 ->
                    Html.h1
                        [ css
                            [ Tw.text_4xl
                            , Tw.font_bold
                            , Tw.tracking_tight
                            , Tw.mt_2
                            , Tw.mb_8
                            , [ Css.qt "Raleway" ] |> Css.fontFamilies
                            , Tw.text_foregroundStrong

                            --, Tw.mb_3_dot_5 |> Css.important
                            ]
                        ]
                        children

                Block.H2 ->
                    Html.h2
                        [ Attr.id (rawTextToId rawText)
                        , Attr.attribute "name" (rawTextToId rawText)
                        , css
                            [ Tw.text_2xl
                            , Tw.font_semibold
                            , Tw.tracking_tight
                            , Tw.mt_12
                            , Tw.text_foregroundStrong
                            , Tw.pb_1
                            , Tw.mb_6
                            , Tw.border_b
                            , [ Css.qt "Raleway" ] |> Css.fontFamilies
                            ]
                        ]
                        [ Html.a
                            [ Attr.href <| "#" ++ rawTextToId rawText
                            , css
                                [ Tw.no_underline |> Css.important
                                ]
                            ]
                            (children
                                ++ [ Html.span
                                        [ Attr.class "anchor-icon"
                                        , css
                                            [ Tw.ml_2
                                            , Tw.text_gray_500
                                            , Tw.select_none
                                            , Tw.text_foregroundStrong
                                            ]
                                        ]
                                        [ Html.text "#" ]
                                   ]
                            )
                        ]

                _ ->
                    (case level of
                        Block.H1 ->
                            Html.h1

                        Block.H2 ->
                            Html.h2

                        Block.H3 ->
                            Html.h3

                        Block.H4 ->
                            Html.h4

                        Block.H5 ->
                            Html.h5

                        Block.H6 ->
                            Html.h6
                    )
                        [ css
                            [ Tw.font_bold
                            , Tw.text_lg
                            , Tw.mt_8
                            , Tw.mb_4
                            , Tw.text_foregroundStrong

                            --, [ Css.qt "Raleway" ] |> Css.fontFamilies
                            ]
                        ]
                        children

        Scaffolded.CodeBlock { body, language } ->
            --shikiDataSource body
            Html.pre [] [ Html.code [] [ Html.text body ] ]

        --SyntaxHighlight.elm body
        --    |> Result.map (SyntaxHighlight.toBlockHtml (Just 1))
        --    |> Result.map Html.fromUnstyled
        --    |> Result.withDefault
        --        (Html.pre
        --            [ css
        --                [ Tw.border_8 |> Css.important
        --                ]
        --            ]
        --            [ Html.code [] [ Html.text details.body ] ]
        --        )
        --    |> List.singleton
        --    |> Html.div
        --        [ css
        --            [ Tw.mt_8
        --            , Tw.mb_8
        --            ]
        --        ]
        Scaffolded.Text string ->
            Html.text string

        Scaffolded.Emphasis content ->
            Html.em [ css [ Tw.italic ] ] content

        Scaffolded.Strong content ->
            Html.strong [ css [ Tw.font_bold ] ] content

        Scaffolded.BlockQuote children ->
            Html.blockquote [] children

        Scaffolded.CodeSpan content ->
            Html.code
                [ css
                    [ Tw.font_semibold
                    , Tw.font_medium
                    , Css.color (Css.rgb 226 0 124) |> Css.important
                    ]
                ]
                [ Html.text content ]

        Scaffolded.Strikethrough children ->
            Html.del [] children

        Link { destination, title, children } ->
            Html.a
                [ Attr.href destination
                , css
                    [ Tw.underline
                    , Tw.text_foregroundStrong
                    , Tw.font_bold
                    ]
                ]
                (title
                    |> Maybe.map Html.text
                    |> Maybe.map List.singleton
                    |> Maybe.withDefault children
                )

        Image image ->
            case image.title of
                Just _ ->
                    Html.img [ Attr.src image.src, Attr.alt image.alt ] []

                Nothing ->
                    Html.img [ Attr.src image.src, Attr.alt image.alt ] []

        UnorderedList { items } ->
            Html.ul
                [ css
                    [ Tw.list_disc
                    , Tw.mb_5
                    , Tw.mt_5
                    ]
                ]
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
                                    Html.li
                                        [ css
                                            [ Tw.ml_7
                                            , Tw.mb_2
                                            , Tw.mt_2
                                            ]
                                        ]
                                        (checkbox :: children)
                        )
                )

        OrderedList { startingIndex, items } ->
            Html.ol
                (case startingIndex of
                    1 ->
                        [ Attr.start startingIndex
                        , css
                            [ Tw.list_decimal
                            , Tw.list_inside
                            , Tw.mt_5
                            , Tw.mb_5
                            ]
                        ]

                    _ ->
                        [ css
                            [ Tw.list_decimal
                            , Tw.list_inside
                            , Tw.mt_5
                            , Tw.mb_5
                            ]
                        ]
                )
                (items
                    |> List.map
                        (\itemBlocks ->
                            Html.li []
                                itemBlocks
                        )
                )

        ThematicBreak ->
            Html.hr [] []

        --HardLineBreak ->
        --Table list ->
        --
        --
        --TableHeader list ->
        --
        --
        --TableBody list ->
        --
        --
        --TableRow list ->
        --
        --
        --TableCell maybeAlignment list ->
        --
        --
        --TableHeaderCell maybeAlignment list ->
        _ ->
            Html.text "TODO"


rawTextToId : String -> String
rawTextToId rawText =
    rawText
        |> String.split " "
        |> String.join "-"
        |> String.toLower


shikiDataSource : String -> DataSource (Html.Html msg)
shikiDataSource codeSnippet =
    DataSource.Port.get "highlight"
        (Json.Encode.string codeSnippet)
        (Shiki.decoder
            |> Decode.map
                (Shiki.view
                    [ Html.Attributes.style "font-family" "IBM Plex Mono"
                    , Html.Attributes.style "padding" "2rem"
                    ]
                )
            |> Decode.map Html.fromUnstyled
        )

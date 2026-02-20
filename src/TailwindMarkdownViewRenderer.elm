module TailwindMarkdownViewRenderer exposing (renderer)

import Css
import Dict exposing (Dict)
import Html.Attributes as HtmlAttr
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr exposing (css)
import Markdown.Block as Block
import Markdown.Html
import Markdown.Renderer
import Markdown.Scaffolded exposing (..)
import Shiki
import Tailwind.Utilities as Tw
import View.Ellie
import Widget.Signup


renderer : Dict String Shiki.Highlighted -> Markdown.Renderer.Renderer (Html msg)
renderer highlights =
    toRenderer
        { renderHtml = Markdown.Html.oneOf (htmlRenderers highlights)
        , renderMarkdown = reduceMarkdown highlights
        }


reduceMarkdown : Dict String Shiki.Highlighted -> Block (Html msg) -> Html msg
reduceMarkdown highlights block =
    case block of
        Paragraph children ->
            Html.p
                [ css
                    [ Tw.bg_background
                    , Tw.text_foreground
                    , Tw.mb_5
                    ]
                ]
                children

        Heading { rawText, level, children } ->
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
                            ]
                        ]
                        children

        CodeBlock info ->
            case Dict.get info.body highlights of
                Just highlighted ->
                    Shiki.view
                        [ HtmlAttr.style "font-family" "IBM Plex Mono"
                        , HtmlAttr.style "padding" "0.75rem 1.25rem"
                        , HtmlAttr.style "font-size" "13px"
                        , HtmlAttr.style "border-radius" "0.5rem"
                        , HtmlAttr.style "margin-top" "2rem"
                        , HtmlAttr.style "margin-bottom" "2rem"
                        ]
                        highlighted
                        |> Html.fromUnstyled

                Nothing ->
                    Html.pre
                        [ css [ Tw.rounded_lg, Tw.p_4 ] ]
                        [ Html.code [] [ Html.text info.body ] ]

        Text string ->
            Html.text string

        Emphasis content ->
            Html.em [ css [ Tw.italic ] ] content

        Strong content ->
            Html.strong [ css [ Tw.font_bold ] ] content

        BlockQuote children ->
            Html.blockquote [] children

        CodeSpan content ->
            Html.code
                [ css
                    [ Tw.bg_selectionBackground
                    , Tw.rounded_lg
                    , Tw.p_1
                    ]
                ]
                [ Html.text content ]

        Strikethrough children ->
            Html.del [] children

        Link { destination, title, children } ->
            Html.a
                [ Attr.href <| slugToAbsoluteUrl destination
                , css
                    [ Tw.underline
                    , Tw.text_foregroundStrong
                    , Tw.text_accent2
                    , Css.hover
                        [ Css.color (Css.rgb 226 0 124)
                        ]
                    ]
                ]
                (title
                    |> Maybe.map Html.text
                    |> Maybe.map List.singleton
                    |> Maybe.withDefault children
                )

        Image image ->
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

        HardLineBreak ->
            Html.br [] []

        Table children ->
            Html.table [] children

        TableHeader children ->
            Html.thead [] children

        TableBody children ->
            Html.tbody [] children

        TableRow children ->
            Html.tr [] children

        TableCell maybeAlignment children ->
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
            Html.td attrs children

        TableHeaderCell maybeAlignment children ->
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
            Html.th attrs children


rawTextToId : String -> String
rawTextToId rawText =
    rawText
        |> String.split " "
        |> String.join "-"
        |> String.toLower


slugToAbsoluteUrl : String -> String
slugToAbsoluteUrl slugOrUrl =
    if slugOrUrl |> String.contains "/" then
        slugOrUrl

    else
        "/" ++ slugOrUrl


htmlRenderers : Dict String Shiki.Highlighted -> List (Markdown.Html.Renderer (List (Html msg) -> Html msg))
htmlRenderers highlights =
    [ Markdown.Html.tag "discord"
        (\_ ->
            Html.div
                [ css
                    [ Tw.flex
                    , Tw.justify_center
                    , Tw.p_8
                    ]
                ]
                [ Html.iframe
                    [ Attr.src "https://discordapp.com/widget?id=534524278847045633&theme=dark"
                    , Attr.width 350
                    , Attr.height 500
                    , Attr.attribute "allowtransparency" "true"
                    , Attr.attribute "frameborder" "0"
                    , Attr.attribute "sandbox" "allow-popups allow-popups-to-escape-sandbox allow-same-origin allow-scripts"
                    ]
                    []
                ]
        )
    , Markdown.Html.tag "signup"
        (\buttonText formId children ->
            Widget.Signup.view2 buttonText formId children
        )
        |> Markdown.Html.withAttribute "buttontext"
        |> Markdown.Html.withAttribute "formid"
    , Markdown.Html.tag "button"
        (\url children ->
            Html.a
                [ Attr.href url
                ]
                children
        )
        |> Markdown.Html.withAttribute "url"
    , Markdown.Html.tag "vimeo"
        (\id _ ->
            vimeoView id
        )
        |> Markdown.Html.withAttribute "id"
    , Markdown.Html.tag "ellie"
        (\id _ ->
            View.Ellie.view id
        )
        |> Markdown.Html.withAttribute "id"
    , Markdown.Html.tag "resource"
        (\name _ url _ ->
            Html.a
                [ css
                    [ Tw.font_bold
                    , Tw.text_lg
                    , Tw.underline
                    ]
                , Attr.href url
                ]
                [ Html.text name ]
        )
        |> Markdown.Html.withAttribute "title"
        |> Markdown.Html.withAttribute "icon"
        |> Markdown.Html.withAttribute "url"
    , Markdown.Html.tag "contact-button"
        (\_ ->
            Html.a
                [ Attr.href "mailto:dillon@incrementalelm.com"
                , css
                    []
                ]
                [ Html.text "Contact" ]
        )
    , Markdown.Html.tag "aside"
        (\title children ->
            Html.details
                [ css
                    [ Tw.border_2
                    , Tw.rounded_lg
                    , Tw.p_4
                    , Tw.border_foregroundLight
                    , Tw.mb_8
                    ]
                ]
                (Html.summary
                    [ css
                        [ Tw.cursor_pointer
                        , Tw.text_xl
                        , Tw.underline
                        , Tw.font_bold
                        , Tw.tracking_tight
                        , [ Css.qt "Raleway" ] |> Css.fontFamilies
                        , Tw.text_foregroundStrong
                        ]
                    ]
                    [ Html.text title
                    ]
                    :: [ Html.div
                            [ css
                                [ Tw.p_4
                                ]
                            ]
                            children
                       ]
                )
        )
        |> Markdown.Html.withAttribute "title"
    ]


vimeoView : String -> Html msg
vimeoView videoId =
    Html.div [ Attr.class "embed-container" ]
        [ Html.iframe
            [ Attr.src <| "https://player.vimeo.com/video/" ++ videoId
            , Attr.attribute "width" "100%"
            , Attr.attribute "height" "100%"
            , Attr.attribute "allow" "autoplay; fullscreen"
            , Attr.attribute "allowfullscreen" ""
            ]
            []
        ]

module TailwindMarkdownRenderer2 exposing (renderer)

import Css
import DataSource exposing (DataSource)
import DataSource.Port
import Html.Attributes as HtmlAttr
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr exposing (css)
import Json.Encode
import Markdown.Block as Block
import Markdown.Html
import Markdown.Renderer
import Markdown.Scaffolded exposing (..)
import OptimizedDecoder as Decode
import Shiki
import Tailwind.Utilities as Tw
import View.Ellie
import Widget.Signup


renderer : Markdown.Renderer.Renderer (DataSource (Html msg))
renderer =
    toRenderer
        { renderHtml = Markdown.Html.oneOf htmlRenderers
        , renderMarkdown = withDataSource reduceHtmlDataSource
        }


reduceHtmlDataSource : Block (Html msg) -> DataSource (Html msg)
reduceHtmlDataSource block =
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
                |> DataSource.succeed

        Heading { rawText, level, children } ->
            (case level of
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
            )
                |> DataSource.succeed

        CodeBlock info ->
            shikiDataSource info

        Text string ->
            DataSource.succeed (Html.text string)

        Emphasis content ->
            DataSource.succeed (Html.em [ css [ Tw.italic ] ] content)

        Strong content ->
            Html.strong [ css [ Tw.font_bold ] ] content
                |> DataSource.succeed

        BlockQuote children ->
            Html.blockquote [] children
                |> DataSource.succeed

        CodeSpan content ->
            Html.code
                [ css
                    [ Tw.bg_selectionBackground
                    , Tw.rounded_lg
                    , Tw.p_1
                    ]
                ]
                [ Html.text content ]
                |> DataSource.succeed

        Strikethrough children ->
            Html.del [] children
                |> DataSource.succeed

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
                |> DataSource.succeed

        Image image ->
            case image.title of
                Just _ ->
                    Html.img [ Attr.src image.src, Attr.alt image.alt ] []
                        |> DataSource.succeed

                Nothing ->
                    Html.img [ Attr.src image.src, Attr.alt image.alt ] []
                        |> DataSource.succeed

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
                |> DataSource.succeed

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
                |> DataSource.succeed

        ThematicBreak ->
            Html.hr [] []
                |> DataSource.succeed

        HardLineBreak ->
            Html.br [] []
                |> DataSource.succeed

        Table children ->
            Html.table [] children
                |> DataSource.succeed

        TableHeader children ->
            Html.thead [] children
                |> DataSource.succeed

        TableBody children ->
            Html.tbody [] children
                |> DataSource.succeed

        TableRow children ->
            Html.tr [] children
                |> DataSource.succeed

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
                |> DataSource.succeed

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
                |> DataSource.succeed


rawTextToId : String -> String
rawTextToId rawText =
    rawText
        |> String.split " "
        |> String.join "-"
        |> String.toLower


shikiDataSource : { body : String, language : Maybe String } -> DataSource (Html msg)
shikiDataSource info =
    DataSource.Port.get "highlight"
        (Json.Encode.object
            [ ( "body", Json.Encode.string info.body )
            , ( "language"
              , info.language
                    |> Maybe.map Json.Encode.string
                    |> Maybe.withDefault Json.Encode.null
              )
            ]
        )
        (Shiki.decoder
            |> Decode.map
                (Shiki.view
                    [ HtmlAttr.style "font-family" "IBM Plex Mono"
                    , HtmlAttr.style "padding" "0.75rem 1.25rem"
                    , HtmlAttr.style "font-size" "13px"
                    , HtmlAttr.style "border-radius" "0.5rem"
                    , HtmlAttr.style "margin-top" "2rem"
                    , HtmlAttr.style "margin-bottom" "2rem"
                    ]
                )
            |> Decode.map Html.fromUnstyled
        )



--htmlRenderers : List (Markdown.Html.Renderer (List (Html msg) -> Html msg))


htmlRenderers : List (Markdown.Html.Renderer (List (DataSource (Html msg)) -> DataSource (Html msg)))
htmlRenderers =
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
                |> DataSource.succeed
        )
    , Markdown.Html.tag "signup"
        (\buttonText formId children ->
            children
                |> DataSource.combine
                |> DataSource.andThen
                    (\resolvedChildren -> DataSource.succeed (Widget.Signup.view2 buttonText formId resolvedChildren))
        )
        |> Markdown.Html.withAttribute "buttontext"
        |> Markdown.Html.withAttribute "formid"
    , Markdown.Html.tag "button"
        (\url children ->
            children
                |> DataSource.combine
                |> DataSource.map
                    (\resolvedChildren ->
                        Html.a
                            [ Attr.href url
                            ]
                            resolvedChildren
                    )
        )
        |> Markdown.Html.withAttribute "url"
    , Markdown.Html.tag "vimeo"
        (\id _ ->
            vimeoView id
                |> DataSource.succeed
        )
        |> Markdown.Html.withAttribute "id"
    , Markdown.Html.tag "ellie"
        (\id _ ->
            View.Ellie.view id
                |> DataSource.succeed
        )
        |> Markdown.Html.withAttribute "id"
    , Markdown.Html.tag "resource"
        (\name _ url _ ->
            --let
            --    kind =
            --        case Dict.get resourceKind icons of
            --            Just myResource ->
            --                --Ok myResource
            --                myResource
            --
            --            Nothing ->
            --                todo ""
            --
            --    --Err
            --    --    { title = "Invalid resource name"
            --    --    , message = []
            --    --    }
            --in
            --View.Resource.view { name = name, url = url, kind = kind }
            Html.a
                [ css
                    [ Tw.font_bold
                    , Tw.text_lg
                    , Tw.underline
                    ]
                , Attr.href url
                ]
                [ Html.text name ]
                |> DataSource.succeed
        )
        |> Markdown.Html.withAttribute "title"
        |> Markdown.Html.withAttribute "icon"
        |> Markdown.Html.withAttribute "url"
    , Markdown.Html.tag "contact-button"
        (\_ ->
            --contactButtonView
            Html.a
                [ Attr.href "mailto:dillon@incrementalelm.com"
                , css
                    []
                ]
                [ Html.text "Contact" ]
                |> DataSource.succeed
        )
    , Markdown.Html.tag "aside"
        (\title children ->
            children
                |> DataSource.combine
                |> DataSource.map
                    (\resolvedChildren ->
                        Html.details
                            [ css
                                [ Tw.border_2

                                --
                                --, Tw.border_dashed
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
                                        [ --css
                                          --    [ Tw.border_4
                                          --
                                          --    --, Tw.border_dashed
                                          --    , Tw.rounded_lg
                                          --    , Tw.p_4
                                          --    ]
                                          css
                                            [ Tw.p_4
                                            ]
                                        ]
                                        resolvedChildren
                                   ]
                            )
                    )
        )
        |> Markdown.Html.withAttribute "title"
    ]


titleView : String -> Html.Html msg
titleView titleText =
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
        [ Html.text titleText ]


subTitleView : String -> Html.Html msg
subTitleView titleText =
    Html.h2
        [ css
            [ Tw.text_3xl
            , Tw.font_bold
            , Tw.tracking_tight
            , Tw.mt_2
            , Tw.mb_8
            , [ Css.qt "Raleway" ] |> Css.fontFamilies
            , Tw.text_foregroundStrong
            ]
        ]
        [ Html.text titleText ]


slugToAbsoluteUrl : String -> String
slugToAbsoluteUrl slugOrUrl =
    if slugOrUrl |> String.contains "/" then
        slugOrUrl

    else
        "/" ++ slugOrUrl


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

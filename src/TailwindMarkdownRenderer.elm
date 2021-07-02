module TailwindMarkdownRenderer exposing (renderer)

import Css
import DarkMode
import Html.Styled as Html
import Html.Styled.Attributes as Attr exposing (css)
import Markdown.Block as Block
import Markdown.Html
import Markdown.Renderer
import SyntaxHighlight
import Tailwind.Utilities as Tw


renderer : Markdown.Renderer.Renderer (Html.Html msg)
renderer =
    { heading = heading
    , paragraph =
        Html.p
            [ css
                [ Tw.bg_background
                , Tw.text_foreground
                , Tw.mb_5
                ]
            ]
    , thematicBreak = Html.hr [] []
    , text = Html.text
    , strong = \content -> Html.strong [ css [ Tw.font_bold ] ] content
    , emphasis = \content -> Html.em [ css [ Tw.italic ] ] content
    , blockQuote = Html.blockquote []
    , codeSpan =
        \content ->
            Html.code
                [ css
                    [ Tw.font_semibold
                    , Tw.font_medium
                    , Css.color (Css.rgb 226 0 124) |> Css.important
                    ]
                ]
                [ Html.text content ]

    --, codeSpan = code
    , link =
        \{ destination, title } body ->
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
                    |> Maybe.withDefault body
                )
    , hardLineBreak = Html.br [] []
    , image =
        \image ->
            case image.title of
                Just _ ->
                    Html.img [ Attr.src image.src, Attr.alt image.alt ] []

                Nothing ->
                    Html.img [ Attr.src image.src, Attr.alt image.alt ] []
    , unorderedList =
        \items ->
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
    , orderedList =
        \startingIndex items ->
            Html.ol
                (case startingIndex of
                    1 ->
                        [ Attr.start startingIndex ]

                    _ ->
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
        Markdown.Html.oneOf
            [ Markdown.Html.tag "discord"
                (\children ->
                    Html.iframe
                        [ Attr.src "https://discordapp.com/widget?id=534524278847045633&theme=dark"
                        , Attr.width 350
                        , Attr.height 500
                        , Attr.attribute "allowtransparency" "true"
                        , Attr.attribute "frameborder" "0"
                        , Attr.attribute "sandbox" "allow-popups allow-popups-to-escape-sandbox allow-same-origin allow-scripts"
                        ]
                        []
                )
            , Markdown.Html.tag "signup"
                --Widget.Signup.view
                (\_ _ _ -> Html.text "signup TODO")
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
                (\id children ->
                    --vimeoView id
                    Html.text "TODO"
                )
                |> Markdown.Html.withAttribute "id"
            , Markdown.Html.tag "ellie"
                (\id children ->
                    --View.Ellie.view id
                    Html.text "TODO"
                )
                |> Markdown.Html.withAttribute "id"
            , Markdown.Html.tag "resources"
                (\children ->
                    --Element.column
                    --    [ Element.spacing 16
                    --    , Element.centerX
                    --    , Element.padding 30
                    --    , Element.width Element.fill
                    --    ]
                    --    children
                    Html.text "TODO"
                )
            , Markdown.Html.tag "resource"
                (\name resourceKind url children ->
                    --let
                    --    todo anything =
                    --        todo anything
                    --
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
                    Html.text "TODO"
                )
                |> Markdown.Html.withAttribute "title"
                |> Markdown.Html.withAttribute "icon"
                |> Markdown.Html.withAttribute "url"
            , Markdown.Html.tag "contact-button"
                (\body ->
                    --contactButtonView
                    Html.a
                        [ Attr.href "mailto:dillon@incrementalelm.com"
                        , css
                            []
                        ]
                        [ Html.text "Contact" ]
                )
            ]
    , codeBlock = codeBlock

    --\{ body, language } ->
    --    let
    --        classes =
    --            -- Only the first word is used in the class
    --            case Maybe.map String.words language of
    --                Just (actualLanguage :: _) ->
    --                    [ Attr.class <| "language-" ++ actualLanguage ]
    --
    --                _ ->
    --                    []
    --    in
    --    Html.pre []
    --        [ Html.code classes
    --            [ Html.text body
    --            ]
    --        ]
    , table =
        Html.table
            [ {-
                 table-layout: auto;
                     text-align: left;
                     width: 100%;
                     margin-top: 2em;
                     margin-bottom: 2em;
              -}
              css
                [--Tw.table_auto
                 --, Tw.w_full
                 --, Tw.mt_4
                 --, Tw.mb_4
                ]
            ]
    , tableHeader = Html.thead []
    , tableBody = Html.tbody []
    , tableRow = Html.tr []
    , strikethrough =
        \children -> Html.del [] children
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


rawTextToId : String -> String
rawTextToId rawText =
    rawText
        |> String.split " "
        |> String.join "-"
        |> String.toLower


heading : { level : Block.HeadingLevel, rawText : String, children : List (Html.Html msg) } -> Html.Html msg
heading { level, rawText, children } =
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



--code : String -> Element msg
--code snippet =
--    Element.el
--        [ Element.Background.color
--            (Element.rgba255 50 50 50 0.07)
--        , Element.Border.rounded 2
--        , Element.paddingXY 5 3
--        , Font.family [ Font.typeface "Roboto Mono", Font.monospace ]
--        ]
--        (Element.text snippet)
--
--


codeBlock : { body : String, language : Maybe String } -> Html.Html msg
codeBlock details =
    SyntaxHighlight.elm details.body
        |> Result.map (SyntaxHighlight.toBlockHtml (Just 1))
        |> Result.map Html.fromUnstyled
        |> Result.withDefault
            (Html.pre
                [ css
                    [ Tw.border_8 |> Css.important
                    ]
                ]
                [ Html.code [] [ Html.text details.body ] ]
            )
        |> List.singleton
        |> Html.div
            [ css
                [ Tw.mt_8
                , Tw.mb_8
                ]
            ]

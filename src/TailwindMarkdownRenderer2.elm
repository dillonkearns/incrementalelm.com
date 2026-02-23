module TailwindMarkdownRenderer2 exposing (renderer)

import BackendTask exposing (BackendTask)
import BackendTask.Custom
import FatalError exposing (FatalError)
import Html.Attributes as HtmlAttr
import Html exposing (Html)
import Html.Attributes as Attr
import Json.Decode as Decode
import Json.Encode
import Markdown.Block as Block
import Markdown.Html
import Markdown.Renderer
import Markdown.Scaffolded exposing (..)
import Shiki
import Tailwind as Tw exposing (batch, classes)
import Tailwind.Theme exposing (accent2, background, s1, s2, s4, s5, s6, s7, s8, s12)
import View.Ellie
import Widget.Signup


renderer : Markdown.Renderer.Renderer (BackendTask FatalError (Html msg))
renderer =
    toRenderer
        { renderHtml = Markdown.Html.oneOf htmlRenderers
        , renderMarkdown = withDataSource reduceHtmlDataSource
        }


reduceHtmlDataSource : Block (Html msg) -> BackendTask FatalError (Html msg)
reduceHtmlDataSource block =
    case block of
        Paragraph children ->
            Html.p
                [ classes
                    [ Tw.bg_simple background
                    , Tw.raw "text-foreground"
                    , Tw.mb s5
                    ]
                ]
                children
                |> BackendTask.succeed

        Heading { rawText, level, children } ->
            (case level of
                Block.H1 ->
                    Html.h1
                        [ classes
                            [ Tw.raw "text-4xl"
                            , Tw.raw "leading-10"
                            , Tw.raw "font-bold"
                            , Tw.raw "tracking-tight"
                            , Tw.mt s2
                            , Tw.mb s8
                            , Tw.raw "font-raleway"
                            , Tw.raw "text-foreground-strong"
                            ]
                        ]
                        children

                Block.H2 ->
                    Html.h2
                        [ Attr.id (rawTextToId rawText)
                        , Attr.attribute "name" (rawTextToId rawText)
                        , classes
                            [ Tw.raw "text-2xl"
                            , Tw.raw "leading-8"
                            , Tw.raw "font-semibold"
                            , Tw.raw "tracking-tight"
                            , Tw.mt s12
                            , Tw.raw "text-foreground-strong"
                            , Tw.pb s1
                            , Tw.mb s6
                            , Tw.border_b
                            , Tw.raw "font-raleway"
                            ]
                        ]
                        [ Html.a
                            [ Attr.href <| "#" ++ rawTextToId rawText
                            , classes
                                [ Tw.raw "!no-underline"
                                ]
                            ]
                            (children
                                ++ [ Html.span
                                        [ Attr.class "anchor-icon"
                                        , classes
                                            [ Tw.ml s2
                                            , Tw.raw "text-gray-500"
                                            , Tw.select_none
                                            , Tw.raw "text-foreground-strong"
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
                        [ classes
                            [ Tw.raw "font-bold"
                            , Tw.raw "text-lg"
                            , Tw.raw "leading-7"
                            , Tw.mt s8
                            , Tw.mb s4
                            , Tw.raw "text-foreground-strong"
                            ]
                        ]
                        children
            )
                |> BackendTask.succeed

        CodeBlock info ->
            shikiDataSource info

        Text string ->
            BackendTask.succeed (Html.text string)

        Emphasis content ->
            BackendTask.succeed (Html.em [ classes [ Tw.italic ] ] content)

        Strong content ->
            Html.strong [ classes [ Tw.raw "font-bold" ] ] content
                |> BackendTask.succeed

        BlockQuote children ->
            Html.blockquote [] children
                |> BackendTask.succeed

        CodeSpan content ->
            Html.code
                [ classes
                    [ Tw.raw "bg-selection-background"
                    , Tw.raw "rounded-lg"
                    , Tw.p s1
                    ]
                ]
                [ Html.text content ]
                |> BackendTask.succeed

        Strikethrough children ->
            Html.del [] children
                |> BackendTask.succeed

        Link { destination, title, children } ->
            Html.a
                [ Attr.href <| slugToAbsoluteUrl destination
                , classes
                    [ Tw.underline
                    , Tw.text_simple accent2
                    , Tw.raw "hover:text-pink-link"
                    ]
                ]
                (title
                    |> Maybe.map Html.text
                    |> Maybe.map List.singleton
                    |> Maybe.withDefault children
                )
                |> BackendTask.succeed

        Image image ->
            case image.title of
                Just _ ->
                    Html.img [ Attr.src image.src, Attr.alt image.alt ] []
                        |> BackendTask.succeed

                Nothing ->
                    Html.img [ Attr.src image.src, Attr.alt image.alt ] []
                        |> BackendTask.succeed

        UnorderedList { items } ->
            Html.ul
                [ classes
                    [ Tw.raw "list-disc"
                    , Tw.mb s5
                    , Tw.mt s5
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
                                        [ classes
                                            [ Tw.ml s7
                                            , Tw.mb s2
                                            , Tw.mt s2
                                            ]
                                        ]
                                        (checkbox :: children)
                        )
                )
                |> BackendTask.succeed

        OrderedList { startingIndex, items } ->
            Html.ol
                (case startingIndex of
                    1 ->
                        [ Attr.start startingIndex
                        , classes
                            [ Tw.raw "list-decimal"
                            , Tw.raw "list-inside"
                            , Tw.mt s5
                            , Tw.mb s5
                            ]
                        ]

                    _ ->
                        [ classes
                            [ Tw.raw "list-decimal"
                            , Tw.raw "list-inside"
                            , Tw.mt s5
                            , Tw.mb s5
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
                |> BackendTask.succeed

        ThematicBreak ->
            Html.hr [] []
                |> BackendTask.succeed

        HardLineBreak ->
            Html.br [] []
                |> BackendTask.succeed

        Table children ->
            Html.table [] children
                |> BackendTask.succeed

        TableHeader children ->
            Html.thead [] children
                |> BackendTask.succeed

        TableBody children ->
            Html.tbody [] children
                |> BackendTask.succeed

        TableRow children ->
            Html.tr [] children
                |> BackendTask.succeed

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
                |> BackendTask.succeed

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
                |> BackendTask.succeed


rawTextToId : String -> String
rawTextToId rawText =
    rawText
        |> String.split " "
        |> String.join "-"
        |> String.toLower


shikiDataSource : { body : String, language : Maybe String } -> BackendTask FatalError (Html msg)
shikiDataSource info =
    BackendTask.Custom.run "highlight"
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
        )
        |> BackendTask.allowFatal


htmlRenderers : List (Markdown.Html.Renderer (List (BackendTask FatalError (Html msg)) -> BackendTask FatalError (Html msg)))
htmlRenderers =
    [ Markdown.Html.tag "discord"
        (\_ ->
            Html.div
                [ classes
                    [ Tw.flex
                    , Tw.justify_center
                    , Tw.p s8
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
                |> BackendTask.succeed
        )
    , Markdown.Html.tag "signup"
        (\buttonText formId children ->
            children
                |> BackendTask.combine
                |> BackendTask.andThen
                    (\resolvedChildren -> BackendTask.succeed (Widget.Signup.view2 buttonText formId resolvedChildren))
        )
        |> Markdown.Html.withAttribute "buttontext"
        |> Markdown.Html.withAttribute "formid"
    , Markdown.Html.tag "button"
        (\url children ->
            children
                |> BackendTask.combine
                |> BackendTask.map
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
                |> BackendTask.succeed
        )
        |> Markdown.Html.withAttribute "id"
    , Markdown.Html.tag "ellie"
        (\id _ ->
            View.Ellie.view id
                |> BackendTask.succeed
        )
        |> Markdown.Html.withAttribute "id"
    , Markdown.Html.tag "resource"
        (\name _ url _ ->
            Html.a
                [ classes
                    [ Tw.raw "font-bold"
                    , Tw.raw "text-lg"
                    , Tw.underline
                    ]
                , Attr.href url
                ]
                [ Html.text name ]
                |> BackendTask.succeed
        )
        |> Markdown.Html.withAttribute "title"
        |> Markdown.Html.withAttribute "icon"
        |> Markdown.Html.withAttribute "url"
    , Markdown.Html.tag "contact-button"
        (\_ ->
            Html.a
                [ Attr.href "mailto:dillon@incrementalelm.com"
                ]
                [ Html.text "Contact" ]
                |> BackendTask.succeed
        )
    , Markdown.Html.tag "aside"
        (\title children ->
            children
                |> BackendTask.combine
                |> BackendTask.map
                    (\resolvedChildren ->
                        Html.details
                            [ classes
                                [ Tw.border_2
                                , Tw.raw "rounded-lg"
                                , Tw.p s4
                                , Tw.raw "border-foreground-light"
                                , Tw.mb s8
                                ]
                            ]
                            (Html.summary
                                [ classes
                                    [ Tw.cursor_pointer
                                    , Tw.raw "text-xl"
                                    , Tw.underline
                                    , Tw.raw "font-bold"
                                    , Tw.raw "tracking-tight"
                                    , Tw.raw "font-raleway"
                                    , Tw.raw "text-foreground-strong"
                                    ]
                                ]
                                [ Html.text title
                                ]
                                :: [ Html.div
                                        [ classes
                                            [ Tw.p s4
                                            ]
                                        ]
                                        resolvedChildren
                                   ]
                            )
                    )
        )
        |> Markdown.Html.withAttribute "title"
    ]


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

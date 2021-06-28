module MarkdownRenderer exposing (TableOfContents, renderer, view)

import Dict
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font as Font
import Element.Input
import Element.Region
import Html exposing (Attribute, Html)
import Html.Attributes exposing (property)
import Json.Encode as Encode exposing (Value)
import Markdown.Block as Block exposing (Block, Inline, ListItem(..), Task(..))
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import Palette
import Regex
import Style
import Style.Helpers
import SyntaxHighlight
import View.Ellie
import View.FontAwesome
import View.Resource
import Widget.Signup


buildToc : List Block -> TableOfContents
buildToc blocks =
    let
        headings =
            gatherHeadings blocks
    in
    headings
        |> List.map Tuple.second
        |> List.map
            (\styledList ->
                { anchorId = styledToString styledList
                , name = styledToString styledList |> rawTextToId
                , level = 1
                }
            )


styledToString : List Inline -> String
styledToString inlines =
    --List.map .string list
    --|> String.join "-"
    -- TODO do I need to hyphenate?
    inlines
        |> Block.extractInlineText


gatherHeadings : List Block -> List ( Block.HeadingLevel, List Inline )
gatherHeadings blocks =
    List.filterMap
        (\block ->
            case block of
                Block.Heading level content ->
                    Just ( level, content )

                _ ->
                    Nothing
        )
        blocks


type alias TableOfContents =
    List { anchorId : String, name : String, level : Int }


view : String -> Result String (List (Element msg))
view markdown =
    case
        markdown
            |> replaceWikiQuotes
            |> Markdown.Parser.parse
    of
        Ok okAst ->
            case Markdown.Renderer.render renderer okAst of
                Ok rendered ->
                    Ok rendered

                Err errors ->
                    Err errors

        Err error ->
            Err (error |> List.map Markdown.Parser.deadEndToString |> String.join "\n")


replaceWikiQuotes : String -> String
replaceWikiQuotes markdownString =
    let
        regex =
            Regex.fromString "\\[\\[(.*)\\]\\]"
                |> Maybe.withDefault Regex.never
    in
    Regex.replace regex
        (\match ->
            case match.submatches of
                [ Just subMatch ] ->
                    "[" ++ subMatch ++ "]"

                _ ->
                    ""
        )
        markdownString


viewWithToc : String -> Result String ( TableOfContents, List (Element msg) )
viewWithToc markdown =
    case
        markdown
            |> Markdown.Parser.parse
    of
        Ok okAst ->
            case Markdown.Renderer.render renderer okAst of
                Ok rendered ->
                    Ok ( buildToc okAst, rendered )

                Err errors ->
                    Err errors

        Err error ->
            Err (error |> List.map Markdown.Parser.deadEndToString |> String.join "\n")


renderer : Markdown.Renderer.Renderer (Element msg)
renderer =
    { heading = heading
    , paragraph =
        Element.paragraph
            [ Element.spacing 15
            , Element.width Element.fill
            ]
    , thematicBreak = Element.paragraph [] []
    , text = \value -> Element.paragraph [] [ Element.text value ]
    , strong = \content -> Element.paragraph [ Font.bold ] content
    , emphasis = \content -> Element.paragraph [ Font.italic ] content
    , strikethrough = \content -> Element.paragraph [ Font.strike ] content
    , codeSpan = code
    , link =
        \{ title, destination } body ->
            if (destination |> String.startsWith "http") || (destination |> String.startsWith "/") then
                Element.newTabLink []
                    { url = destination
                    , label =
                        Element.paragraph
                            [ Font.color (Element.rgb255 17 132 206)
                            , Element.mouseOver [ Font.color (Element.rgb255 234 21 122) ]
                            , Element.htmlAttribute (Html.Attributes.style "overflow-wrap" "break-word")
                            , Element.htmlAttribute (Html.Attributes.style "word-break" "break-word")
                            ]
                            body
                    }

            else
                Element.link
                    [ Element.htmlAttribute
                        (Html.Attributes.attribute "elm-pages:prefetch" "")
                    ]
                    { url = destination
                    , label =
                        Element.paragraph
                            [ Font.color (Element.rgb255 17 132 206)
                            , Element.mouseOver [ Font.color (Element.rgb255 234 21 122) ]
                            , Element.htmlAttribute (Html.Attributes.style "overflow-wrap" "break-word")
                            , Element.htmlAttribute (Html.Attributes.style "word-break" "break-word")
                            ]
                            body
                    }
    , image =
        \image ->
            Element.image
                [ Element.centerX
                , Element.width (Element.fill |> Element.maximum 600)
                ]
                { src = image.src, description = image.alt }

    --|> List.singleton
    --|> Element.textColumn
    --    [ Element.spacing 15
    --    , Element.width Element.fill
    --    ]
    , hardLineBreak = Html.br [] [] |> Element.html
    , blockQuote = Palette.blockQuote
    , unorderedList =
        \items ->
            Element.column [ Element.spacing 15, Element.paddingEach { left = 20, top = 0, right = 0, bottom = 0 } ]
                (items
                    |> List.map
                        (\(ListItem task children) ->
                            Element.paragraph [ Element.spacing 5 ]
                                [ Element.row
                                    [ Element.alignTop ]
                                    ((case task of
                                        IncompleteTask ->
                                            Element.Input.defaultCheckbox False

                                        CompletedTask ->
                                            Element.Input.defaultCheckbox True

                                        NoTask ->
                                            Element.text "•"
                                     )
                                        :: Element.text " "
                                        :: children
                                    )
                                ]
                        )
                )
    , orderedList =
        \startingIndex items ->
            Element.column [ Element.spacing 15 ]
                (items
                    |> List.indexedMap
                        (\index itemBlocks ->
                            Element.wrappedRow
                                [ Element.spacing 5
                                , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 20 }
                                ]
                                [ Element.paragraph
                                    [ Element.alignTop ]
                                    (Element.text (String.fromInt (startingIndex + index) ++ ". ") :: itemBlocks)
                                ]
                        )
                )
    , codeBlock = codeBlock
    , table = Element.column []
    , tableHeader =
        Element.column
            [ Font.bold
            , Element.width Element.fill
            , Font.center
            ]
    , tableBody = Element.column []
    , tableRow = Element.row [ Element.height Element.fill, Element.width Element.fill ]
    , tableHeaderCell =
        \maybeAlignment children ->
            Element.paragraph
                tableBorder
                children
    , tableCell =
        \maybeAlignment children ->
            Element.paragraph
                tableBorder
                children
    , html =
        Markdown.Html.oneOf
            [ Markdown.Html.tag "discord"
                (\children ->
                    Html.iframe
                        [ Html.Attributes.src "https://discordapp.com/widget?id=534524278847045633&theme=dark"
                        , Html.Attributes.width 350
                        , Html.Attributes.height 500
                        , Html.Attributes.attribute "allowtransparency" "true"
                        , Html.Attributes.attribute "frameborder" "0"
                        , Html.Attributes.attribute "sandbox" "allow-popups allow-popups-to-escape-sandbox allow-same-origin allow-scripts"
                        ]
                        []
                        |> Element.html
                )
            , Markdown.Html.tag "signup" Widget.Signup.view
                |> Markdown.Html.withAttribute "buttontext"
                |> Markdown.Html.withAttribute "formid"
            , Markdown.Html.tag "button"
                (\url children -> buttonView { url = url, children = children })
                |> Markdown.Html.withAttribute "url"
            , Markdown.Html.tag "vimeo"
                (\id children -> vimeoView id)
                |> Markdown.Html.withAttribute "id"
            , Markdown.Html.tag "ellie"
                (\id children -> View.Ellie.view id)
                |> Markdown.Html.withAttribute "id"
            , Markdown.Html.tag "resources"
                (\children ->
                    Element.column
                        [ Element.spacing 16
                        , Element.centerX
                        , Element.padding 30
                        , Element.width Element.fill
                        ]
                        children
                )
            , Markdown.Html.tag "resource"
                (\name resourceKind url children ->
                    let
                        todo anything =
                            todo anything

                        kind =
                            case Dict.get resourceKind icons of
                                Just myResource ->
                                    --Ok myResource
                                    myResource

                                Nothing ->
                                    todo ""

                        --Err
                        --    { title = "Invalid resource name"
                        --    , message = []
                        --    }
                    in
                    View.Resource.view { name = name, url = url, kind = kind }
                )
                |> Markdown.Html.withAttribute "title"
                |> Markdown.Html.withAttribute "icon"
                |> Markdown.Html.withAttribute "url"
            , Markdown.Html.tag "contact-button" (\body -> contactButtonView)

            -- , Markdown.Html.tag "Oembed"
            --     (\url children ->
            --         Oembed.view [] Nothing url
            --             |> Maybe.map Element.html
            --             |> Maybe.withDefault Element.none
            --             |> Element.el [ Element.centerX ]
            --     )
            --     |> Markdown.Html.withAttribute "url"
            -- , Markdown.Html.tag "ellie-output"
            --     (\ellieId children ->
            --         -- Oembed.view [] Nothing url
            --         --     |> Maybe.map Element.html
            --         --     |> Maybe.withDefault Element.none
            --         --     |> Element.el [ Element.centerX ]
            --         Ellie.outputTab ellieId
            --     )
            --     |> Markdown.Html.withAttribute "id"
            ]
    }


alternateTableRowBackground =
    Element.rgb255 245 247 249


tableBorder =
    [ Element.Border.color (Element.rgb255 223 226 229)
    , Element.Border.width 1
    , Element.Border.solid
    , Element.paddingXY 6 13
    , Element.height Element.fill
    ]


icons =
    [ ( "Video", View.Resource.Video )
    , ( "Library", View.Resource.Library )
    , ( "App", View.Resource.App )
    , ( "Article", View.Resource.Article )
    , ( "Exercise", View.Resource.Exercise )
    , ( "Book", View.Resource.Book )
    ]
        |> Dict.fromList


buttonView : { url : String, children : List (Element msg) } -> Element msg
buttonView details =
    Element.link
        [ Element.centerX ]
        { url = details.url
        , label =
            Style.Helpers.button
                { fontColor = .mainBackground
                , backgroundColor = .highlight
                , size = Style.fontSize.body
                }
                details.children
        }
        |> Element.el [ Element.centerX ]


contactButtonView : Element msg
contactButtonView =
    Element.newTabLink
        [ Element.centerX ]
        { url = "mailto:dillon@incrementalelm.com"
        , label =
            Style.Helpers.button
                { fontColor = .mainBackground
                , backgroundColor = .highlight
                , size = Style.fontSize.body
                }
                [ View.FontAwesome.icon "far fa-envelope" |> Element.el []
                , Element.text "dillon@incrementalelm.com"
                ]
        }
        |> Element.el [ Element.centerX ]


rawTextToId rawText =
    rawText
        |> String.toLower
        |> String.replace " " ""


heading : { level : Block.HeadingLevel, rawText : String, children : List (Element msg) } -> Element msg
heading { level, rawText, children } =
    Element.paragraph
        ((case level of
            Block.H1 ->
                [ Font.size 36
                , Font.bold
                , Font.center
                ]

            Block.H2 ->
                [ Font.size 24
                , Font.semiBold
                ]

            _ ->
                [ Font.size 20
                , Font.semiBold
                ]
         )
            ++ [ Font.bold
               , Font.family [ Font.typeface "Raleway" ]
               , Element.Region.heading (Block.headingLevelToInt level)
               , Element.htmlAttribute
                    (Html.Attributes.attribute "name" (rawTextToId rawText))
               , Element.htmlAttribute
                    (Html.Attributes.id (rawTextToId rawText))
               ]
        )
        children


code : String -> Element msg
code snippet =
    Element.el
        [ Element.Background.color
            (Element.rgba 0 0 0 0.04)
        , Element.Border.rounded 2
        , Element.paddingXY 5 3
        , Font.family [ Font.monospace ]
        ]
        (Element.text snippet)


codeBlock : { body : String, language : Maybe String } -> Element msg
codeBlock details =
    SyntaxHighlight.elm details.body
        |> Result.map (SyntaxHighlight.toBlockHtml (Just 1))
        |> Result.map Element.html
        |> Result.map (Element.el [ Element.width Element.fill ])
        |> Result.withDefault (Element.text "")


editorValue : String -> Attribute msg
editorValue value =
    value
        |> String.trim
        |> Encode.string
        |> property "editorValue"


vimeoView : String -> Element msg
vimeoView videoId =
    Html.div [ Html.Attributes.class "embed-container" ]
        [ Html.iframe
            [ Html.Attributes.src <| "https://player.vimeo.com/video/" ++ videoId
            , Html.Attributes.attribute "width" "100%"
            , Html.Attributes.attribute "height" "100%"
            , Html.Attributes.attribute "allow" "autoplay; fullscreen"
            , Html.Attributes.attribute "allowfullscreen" ""
            ]
            []
        ]
        |> Element.html
        |> Element.el [ Element.width Element.fill ]

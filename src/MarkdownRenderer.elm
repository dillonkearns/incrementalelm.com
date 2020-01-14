module MarkdownRenderer exposing (TableOfContents, view)

-- import Ellie

import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font as Font
import Element.Region
import Html exposing (Attribute, Html)
import Html.Attributes exposing (property)
import Html.Events exposing (on)
import Json.Encode as Encode exposing (Value)
import Markdown.Block
import Markdown.Html
import Markdown.Parser
import Pages
import Style
import Style.Helpers
import View.DripSignupForm
import View.FontAwesome
import View.SignupForm


buildToc : List Markdown.Block.Block -> TableOfContents
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


styledToString : List Markdown.Block.Inline -> String
styledToString list =
    List.map .string list
        |> String.join "-"


gatherHeadings : List Markdown.Block.Block -> List ( Int, List Markdown.Block.Inline )
gatherHeadings blocks =
    List.filterMap
        (\block ->
            case block of
                Markdown.Block.Heading level content ->
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
            |> Markdown.Parser.parse
    of
        Ok okAst ->
            case Markdown.Parser.render renderer okAst of
                Ok rendered ->
                    Ok rendered

                Err errors ->
                    Err errors

        Err error ->
            Err (error |> List.map Markdown.Parser.deadEndToString |> String.join "\n")


viewWithToc : String -> Result String ( TableOfContents, List (Element msg) )
viewWithToc markdown =
    case
        markdown
            |> Markdown.Parser.parse
    of
        Ok okAst ->
            case Markdown.Parser.render renderer okAst of
                Ok rendered ->
                    Ok ( buildToc okAst, rendered )

                Err errors ->
                    Err errors

        Err error ->
            Err (error |> List.map Markdown.Parser.deadEndToString |> String.join "\n")


renderer : Markdown.Parser.Renderer (Element msg)
renderer =
    { heading = heading
    , raw =
        Element.paragraph
            [ Element.spacing 15 ]
    , thematicBreak = Element.none
    , plain = \content -> Element.el [] (Element.text content)
    , bold = \content -> Element.el [ Font.bold ] (Element.text content)
    , italic = \content -> Element.el [ Font.italic ] (Element.text content)
    , code = code
    , link =
        \link body ->
            -- Pages.isValidRoute link.destination
            --     |> Result.map
            --         (\() ->
            Element.newTabLink
                []
                { url = link.destination
                , label =
                    Element.row
                        [ Font.color
                            (Element.rgb255
                                17
                                132
                                206
                            )
                        , Element.mouseOver
                            [ Font.color
                                (Element.rgb255
                                    234
                                    21
                                    122
                                )
                            ]
                        , Element.htmlAttribute (Html.Attributes.style "display" "inline-flex")
                        ]
                        body
                }
                |> Ok

    -- )
    , image =
        \image body ->
            -- Pages.isValidRoute image.src
            --     |> Result.map
            -- (\() ->
            Element.image [ Element.width Element.fill ] { src = image.src, description = body }
                |> Ok

    -- )
    , unorderedList =
        \items ->
            Element.column [ Element.spacing 15 ]
                (items
                    |> List.map
                        (\itemBlocks ->
                            Element.wrappedRow
                                [ Element.spacing 5
                                , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 20 }
                                ]
                                [ Element.paragraph
                                    [ Element.alignTop ]
                                    (Element.text " • " :: itemBlocks)
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
    , html =
        Markdown.Html.oneOf
            [ Markdown.Html.tag "Signup"
                (\buttonText formId body ->
                    [ Element.column
                        [ Font.center
                        , Element.spacing 30
                        , Element.centerX
                        ]
                        body
                    , View.DripSignupForm.viewNew buttonText formId { maybeReferenceId = Nothing }
                        |> Element.html
                        |> Element.el [ Element.width Element.fill ]
                    , [ Element.text "We'll never share your email. Unsubscribe any time." ]
                        |> Element.paragraph
                            [ Font.color (Element.rgba255 0 0 0 0.5)
                            , Font.size 14
                            , Font.center
                            ]
                    ]
                        |> Element.column
                            [ Element.width Element.fill
                            , Element.padding 20
                            , Element.spacing 20
                            , Element.Border.shadow { offset = ( 0, 0 ), size = 1, blur = 4, color = Element.rgb 0.8 0.8 0.8 }
                            , Element.mouseOver
                                [ Element.Border.shadow { offset = ( 0, 0 ), size = 1, blur = 4, color = Element.rgb 0.85 0.85 0.85 } ]
                            , Element.width (Element.fill |> Element.maximum 500)
                            , Element.centerX
                            ]
                        |> Element.el []
                )
                |> Markdown.Html.withAttribute "buttonText"
                |> Markdown.Html.withAttribute "formId"
            , Markdown.Html.tag "Button"
                (\url children -> buttonView { url = url, children = children })
                |> Markdown.Html.withAttribute "url"
            , Markdown.Html.tag "ContactButton" (\body -> contactButtonView)

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


heading : { level : Int, rawText : String, children : List (Element msg) } -> Element msg
heading { level, rawText, children } =
    Element.paragraph
        ((case level of
            1 ->
                [ Font.size 36
                , Font.bold
                , Font.center
                , Font.family [ Font.typeface "Raleway" ]
                ]

            -- 36
            2 ->
                -- 24
                [ Font.size 36
                , Font.bold
                , Font.center
                , Font.family [ Font.typeface "Raleway" ]
                ]

            _ ->
                -- 20
                [ Font.size 36
                , Font.bold
                , Font.center
                , Font.family [ Font.typeface "Raleway" ]
                ]
         )
            ++ [ Element.Region.heading level
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
    Html.node "code-editor"
        [ editorValue details.body
        , Html.Attributes.style "white-space" "normal"
        ]
        []
        |> Element.html
        |> Element.el [ Element.width Element.fill ]


editorValue : String -> Attribute msg
editorValue value =
    value
        |> String.trim
        |> Encode.string
        |> property "editorValue"

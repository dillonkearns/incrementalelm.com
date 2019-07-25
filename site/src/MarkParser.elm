module MarkParser exposing (Metadata, PageOrPost, document)

import Dict exposing (Dict)
import Element exposing (Element)
import Element.Border
import Element.Font as Font
import Element.Region
import Html exposing (Html)
import Html.Attributes as Attr
import Mark
import Mark.Error
import MarkupPages.Parser
import Style
import Style.Helpers
import View.CodeSnippet
import View.DripSignupForm
import View.FontAwesome


normalizedUrl url =
    url
        |> String.split "#"
        |> List.head
        |> Maybe.withDefault ""


type alias PageOrPost msg =
    { body : List (Element msg)
    , metadata : Metadata msg
    }


document :
    Dict String String
    -> List String
    -> Element msg
    ->
        Mark.Document
            { body : List (Element msg)
            , metadata : Metadata msg
            }
document imageAssets routes indexView =
    Mark.documentWith
        (\meta body ->
            { metadata = meta
            , body = body
            }
        )
        -- We have some required metadata that starts our document.
        { metadata = metadata
        , body = Mark.manyOf (blocks imageAssets routes indexView)
        }


document2 :
    Dict String String
    -> List String
    -> Element msg
    ->
        Mark.Document
            { body : List (Element msg)
            , metadata : Metadata msg
            }
document2 imageAssets routes indexView =
    MarkupPages.Parser.document
        { imageAssets = imageAssets
        , routes = routes
        , indexView = indexView
        }
        (blocks imageAssets routes indexView)


blocks :
    Dict String String
    -> List String
    -> Element msg
    -> List (Mark.Block (Element msg))
blocks imageAssets routes indexView =
    let
        header : Mark.Block (Element msg)
        header =
            Mark.block "H1"
                (\children ->
                    Element.paragraph
                        [ Font.size 24
                        , Font.semiBold
                        , Font.center
                        , Font.family [ Font.typeface "Raleway" ]
                        ]
                        children
                )
                text

        h2 : Mark.Block (Element msg)
        h2 =
            Mark.block "H2"
                (\children ->
                    Element.paragraph
                        [ Font.size 18
                        , Font.semiBold
                        , Font.alignLeft
                        , Font.family [ Font.typeface "Raleway" ]
                        ]
                        children
                )
                text

        image : Mark.Block (Element msg)
        image =
            Mark.record "Image"
                (\src description ->
                    Element.image
                        [ Element.width (Element.fill |> Element.maximum 600)
                        , Element.centerX
                        ]
                        { src = src
                        , description = description
                        }
                        |> Element.el [ Element.centerX ]
                )
                |> Mark.field "src"
                    (Mark.string
                        |> Mark.verify
                            (\imageSrc ->
                                case Dict.get imageSrc imageAssets of
                                    Just hashedImagePath ->
                                        Ok hashedImagePath

                                    Nothing ->
                                        Err
                                            { title = "Could not image `" ++ imageSrc ++ "`"
                                            , message =
                                                [ "Must be one of\n"
                                                , Dict.keys imageAssets |> String.join "\n"
                                                ]
                                            }
                            )
                    )
                |> Mark.field "description" Mark.string
                |> Mark.toBlock

        signupForm : Mark.Block (Element msg)
        signupForm =
            Mark.record "Signup"
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
                |> Mark.field "buttonText" Mark.string
                |> Mark.field "formId" Mark.string
                |> Mark.field "body"
                    (Mark.manyOf
                        [ header
                        , list
                        ]
                    )
                |> Mark.toBlock

        text : Mark.Block (List (Element msg))
        text =
            Mark.textWith
                { view =
                    \styles string ->
                        viewText styles string
                , replacements = Mark.commonReplacements
                , inlines =
                    [ Mark.annotation "link"
                        (\texts url ->
                            Element.link []
                                { url = url
                                , label =
                                    Element.row [ Element.htmlAttribute (Attr.style "display" "inline-flex") ]
                                        (List.map (applyTuple viewText) texts)
                                }
                        )
                        |> Mark.field "url"
                            (Mark.string
                                |> Mark.verify
                                    (\url ->
                                        if List.member (normalizedUrl url) routes then
                                            Ok url

                                        else
                                            Err
                                                { title = "Unknown relative URL " ++ url
                                                , message =
                                                    [ url
                                                    , "\nMust be one of\n"
                                                    , String.join "\n" routes
                                                    ]
                                                }
                                    )
                            )
                    , Mark.verbatim "code"
                        (\str ->
                            Element.el [ Font.color (Element.rgb255 200 50 50) ] (Element.text str)
                        )
                    ]
                }

        list : Mark.Block (Element msg)
        list =
            Mark.tree "List" renderList (Mark.map (Element.paragraph []) text)
    in
    [ header
    , h2
    , image
    , list
    , code
    , indexContent indexView
    , signupForm
    , button
    , contactButton
    , navHeader
        [ Font.size 24
        , Font.semiBold
        , Font.alignLeft
        , Font.family [ Font.typeface "Raleway" ]
        ]
        text
    , Mark.map
        (Element.paragraph
            [ Element.spacing 15 ]
        )
        text
    ]


contactButton : Mark.Block (Element msg)
contactButton =
    Mark.record "ContactButton" contactButtonView
        |> Mark.toBlock


navHeader : List (Element.Attribute msg) -> Mark.Block (List (Element msg)) -> Mark.Block (Element msg)
navHeader attrs textParser =
    Mark.record "Navheader"
        (\elements id ->
            Element.paragraph
                (Element.Region.heading 3
                    :: Element.htmlAttribute (Attr.id id)
                    :: attrs
                )
                elements
        )
        |> Mark.field "title" textParser
        |> Mark.field "id" Mark.string
        |> Mark.toBlock


button : Mark.Block (Element msg)
button =
    Mark.record "Button"
        (\body url -> buttonView { body = body, url = url })
        |> Mark.field "body" Mark.string
        |> Mark.field "url" Mark.string
        |> Mark.toBlock


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


buttonView : { url : String, body : String } -> Element msg
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
                [ Element.text details.body
                ]
        }
        |> Element.el [ Element.centerX ]



{- Handle Text -}


titleText : Mark.Block (List { styled : Element msg, raw : String })
titleText =
    Mark.textWith
        { view =
            \styles string ->
                { styled = viewText styles string
                , raw = string
                }
        , replacements = Mark.commonReplacements
        , inlines = []
        }


{-| Render a text fragment.
-}
applyTuple : (a -> b -> c) -> ( a, b ) -> c
applyTuple fn ( one, two ) =
    fn one two


viewText : { a | bold : Bool, italic : Bool, strike : Bool } -> String -> Element msg
viewText styles string =
    Element.el (stylesFor styles) (Element.text string)


stylesFor : { a | bold : Bool, italic : Bool, strike : Bool } -> List (Element.Attribute b)
stylesFor styles =
    [ if styles.bold then
        Just Font.bold

      else
        Nothing
    , if styles.italic then
        Just Font.italic

      else
        Nothing
    , if styles.strike then
        Just Font.strike

      else
        Nothing
    ]
        |> List.filterMap identity



{- Handle Metadata -}


type alias Metadata msg =
    { description : String
    , title : { styled : Element msg, raw : String }
    }


metadata : Mark.Block (Metadata msg)
metadata =
    Mark.record "Article"
        (\description title ->
            { description = description
            , title = title
            }
        )
        |> Mark.field "description" Mark.string
        |> Mark.field "title"
            (Mark.map
                gather
                titleText
            )
        |> Mark.toBlock


gather : List { styled : Element msg, raw : String } -> { styled : Element msg, raw : String }
gather myList =
    let
        styled =
            myList
                |> List.map .styled
                |> Element.paragraph []

        raw =
            myList
                |> List.map .raw
                |> String.join " "
    in
    { styled = styled, raw = raw }



{- Handle Blocks -}


indexContent : Element msg -> Mark.Block (Element msg)
indexContent content =
    Mark.record "IndexContent"
        (\postsPath ->
            content
        )
        |> Mark.field "posts"
            (Mark.string
                |> Mark.verify
                    (\postDirectory ->
                        if postDirectory == "articles" then
                            Ok "articles"

                        else
                            Err
                                { title = "Could not find posts path `" ++ postDirectory ++ "`"
                                , message = "Must be one of " :: [ "articles" ]
                                }
                    )
            )
        |> Mark.toBlock


code : Mark.Block (Element msg)
code =
    Mark.block "Code"
        (\codeSnippet ->
            codeSnippet
                |> View.CodeSnippet.codeEditor
                |> Element.el [ Font.size 16 ]
        )
        Mark.string



{- Handling bulleted and numbered lists -}
-- Note: we have to define this as a separate function because
-- `Items` and `Node` are a pair of mutually recursive data structures.
-- It's easiest to render them using two separate functions:
-- renderList and renderItem


renderList : Mark.Enumerated (Element msg) -> Element msg
renderList (Mark.Enumerated enum) =
    Element.column []
        (List.map (renderItem enum.icon) enum.items)


renderItem : Mark.Icon -> Mark.Item (Element msg) -> Element msg
renderItem icon (Mark.Item item) =
    Element.column [ Element.width Element.fill, Element.spacing 20 ]
        [ Element.row [ Element.width Element.fill, Element.spacing 10 ]
            [ Element.el [ Element.alignTop, Element.paddingEach { top = 0, right = 0, bottom = 0, left = 20 } ]
                (Element.text
                    (case icon of
                        Mark.Bullet ->
                            "•"

                        Mark.Number ->
                            (item.index |> Tuple.first |> (\n -> n + 1) |> String.fromInt)
                                ++ "."
                    )
                )
            , Element.row [ Element.width Element.fill ] item.content
            ]
        , renderList item.children
        ]

module MarkParser exposing (Metadata, document)

import Dict exposing (Dict)
import Element exposing (Element)
import Element.Border
import Element.Font as Font
import Element.Region
import GoogleForm
import Html exposing (Html)
import Html.Attributes as Attr
import Index
import Mark
import Mark.Error
import MarkupPages.Parser exposing (PageOrPost)
import Style
import Style.Helpers
import View.CodeSnippet
import View.DripSignupForm
import View.FontAwesome
import View.Resource


normalizedUrl url =
    url
        |> String.split "#"
        |> List.head
        |> Maybe.withDefault ""


document :
    Dict String String
    -> List String
    -> Maybe (List ( List String, PageOrPost msg (Metadata msg) (Metadata msg) ))
    -> Mark.Document (PageOrPost msg (Metadata msg) (Metadata msg))
document imageAssets routes posts =
    MarkupPages.Parser.document
        { imageAssets = imageAssets
        , routes = routes
        , indexView = posts
        }
        (blocks { imageAssets = imageAssets, routes = routes, indexView = posts })


blocks :
    MarkupPages.Parser.AppData msg
    -> List (Mark.Block (Element msg))
blocks appData =
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
                |> Mark.field "src" (MarkupPages.Parser.imageSrc appData)
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
                                    Element.row
                                        [ Font.color
                                            (Element.rgb
                                                (17 / 255)
                                                (132 / 255)
                                                (206 / 255)
                                            )
                                        , Element.mouseOver
                                            [ Font.color
                                                (Element.rgb
                                                    (234 / 255)
                                                    (21 / 255)
                                                    (122 / 255)
                                                )
                                            ]
                                        , Element.htmlAttribute
                                            (Attr.style "display" "inline-flex")
                                        ]
                                        (List.map (applyTuple viewText) texts)
                                }
                        )
                        |> Mark.field "url"
                            (Mark.string
                                |> Mark.verify
                                    (\url ->
                                        if url |> String.startsWith "http" then
                                            Ok url

                                        else if List.member (normalizedUrl url) appData.routes then
                                            Ok url

                                        else
                                            Err
                                                { title = "Unknown relative URL " ++ url
                                                , message =
                                                    [ url
                                                    , "\nMust be one of\n"
                                                    , String.join "\n" appData.routes
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
    , indexContent appData.indexView
    , signupForm
    , vimeo
    , button
    , contactButton
    , googleForm
    , resource
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


resource : Mark.Block (Element msg)
resource =
    Mark.record "Resource"
        (\name resourceKind url ->
            View.Resource.view { name = name, url = url, kind = resourceKind }
        )
        |> Mark.field "title" Mark.string
        |> Mark.field "icon" iconBlock
        |> Mark.field "url" Mark.string
        |> Mark.toBlock


icons =
    [ ( "Video", View.Resource.Video )
    , ( "Library", View.Resource.Library )
    , ( "App", View.Resource.App )
    , ( "Article", View.Resource.Article )
    , ( "Exercise", View.Resource.Exercise )
    , ( "Book", View.Resource.Book )
    ]
        |> Dict.fromList


iconBlock : Mark.Block View.Resource.ResourceKind
iconBlock =
    -- Mark.oneOf
    Mark.string
        |> Mark.verify
            (\iconName ->
                case Dict.get iconName icons of
                    Just myResource ->
                        Ok myResource

                    Nothing ->
                        Err
                            { title = "Invalid resource name"
                            , message = []
                            }
            )


googleForm : Mark.Block (Element msg)
googleForm =
    Mark.block "GoogleForm"
        (\formId -> GoogleForm.view formId)
        Mark.string


vimeo : Mark.Block (Element msg)
vimeo =
    Mark.block "Vimeo" (\videoId -> vimeoView videoId) Mark.string


vimeoView : String -> Element msg
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
        |> Element.html
        |> Element.el [ Element.width Element.fill ]


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


indexContent : Maybe (List ( List String, PageOrPost msg (Metadata msg) (Metadata msg) )) -> Mark.Block (Element msg)
indexContent posts =
    Mark.record "IndexContent"
        (\postsPath ->
            posts |> Maybe.map Index.view |> Maybe.withDefault Element.none
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
        |> Mark.verify
            (\value ->
                case posts of
                    Just msgElement ->
                        Ok value

                    Nothing ->
                        Err
                            { title = "IndexContent blocks are only valid in Pages"
                            , message = [ "Try creating your index page in `_pages` instead of `_posts`." ]
                            }
            )


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

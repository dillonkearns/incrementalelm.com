module MarkParser exposing (document, parse)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region
import Html.Attributes
import Mark exposing (Document)
import Mark.Default
import Parser.Advanced
import Style
import Style.Helpers
import View.CodeSnippet
import View.Ellie
import View.FontAwesome
import View.Resource


type alias RelativeUrl =
    List String


parse :
    List RelativeUrl
    -> String
    -> Result (List (Parser.Advanced.DeadEnd Mark.Context Mark.Problem)) (model -> Element msg)
parse validRelativeUrls =
    Mark.parse (document validRelativeUrls)


document : List RelativeUrl -> Mark.Document (model -> Element msg)
document validRelativeUrls =
    let
        defaultText =
            textWith validRelativeUrls Mark.Default.defaultTextStyle
    in
    Mark.document
        (\children model ->
            Element.textColumn
                [ Element.width Element.fill
                , Element.centerX
                , Element.spacing 30
                , Font.size 18
                ]
                (List.map (\view -> view model) children)
        )
        (Mark.manyOf
            [ Mark.Default.header [ Font.size 36, Font.center, Font.family [ Font.typeface "Raleway" ], Font.bold ] defaultText
            , subHeader [ Font.size 24, Font.semiBold, Font.alignLeft, Font.family [ Font.typeface "Raleway" ] ] defaultText
            , Mark.Default.list
                { style = listStyles
                , icon = Mark.Default.listIcon
                }
                defaultText

            -- |> Mark.map (\item model -> [ item model ] |> Element.paragraph [ Element.width (Element.px 10) ])
            , image
            , ellie
            , contactButton
            , resources
            , resource |> Mark.map (\thing model -> thing)
            , monospace

            -- Toplevel Text
            , Mark.map (\viewEls model -> Element.paragraph [] (viewEls model)) defaultText
            ]
        )


subHeader : List (Element.Attribute msg) -> Mark.Block (model -> List (Element msg)) -> Mark.Block (model -> Element msg)
subHeader attrs textParser =
    Mark.block "Subheader"
        (\elements model ->
            Element.paragraph
                (Element.Region.heading 3 :: attrs)
                (elements model)
        )
        textParser


contactButton : Mark.Block (model -> Element msg)
contactButton =
    Mark.stub "ContactButton" (\model -> contactButtonView)


contactButtonView : Element msg
contactButtonView =
    Element.newTabLink
        [ Element.centerX ]
        { url = "mailto:info@incrementalelm.com"
        , label =
            Style.Helpers.button
                { fontColor = .mainBackground
                , backgroundColor = .highlight
                , size = Style.fontSize.body
                }
                [ View.FontAwesome.icon "far fa-envelope" |> Element.el []
                , Element.text "info@incrementalelm.com"
                ]
        }
        |> Element.el [ Element.centerX ]


textWith :
    List RelativeUrl
    ->
        { code : List (Element.Attribute msg)
        , link : List (Element.Attribute msg)
        , inlines : List (Mark.Inline (model -> Element msg))
        , replacements : List Mark.Replacement
        }
    -> Mark.Block (model -> List (Element msg))
textWith validRelativeUrls config =
    Mark.map
        (\els model ->
            List.map (\view -> view model) els
        )
        (Mark.text
            { view = textFragment
            , inlines =
                [ link validRelativeUrls config.link
                , code config.code
                ]
                    ++ config.inlines
            , replacements = config.replacements
            }
        )


monospace : Mark.Block (model -> Element msg)
monospace =
    Mark.block "Monospace"
        (\codeSnippet model ->
            codeSnippet
                |> View.CodeSnippet.codeEditor
                |> Element.el [ Font.size 16 ]
        )
        Mark.multiline


resources : Mark.Block (model -> Element msg)
resources =
    Mark.block "Resources"
        (\resourceElements model ->
            Element.column
                [ Element.spacing 16
                , Element.centerX
                , Element.padding 30
                , Element.width Element.fill
                ]
                resourceElements
        )
        (Mark.manyOf
            [ resource
            ]
        )


resource : Mark.Block (Element msg)
resource =
    Mark.record3 "Resource"
        (\name resourceKind url ->
            View.Resource.view { name = name, url = url, kind = resourceKind }
        )
        (Mark.field "title" Mark.string)
        (Mark.field "icon" iconBlock)
        (Mark.field "url" Mark.string)


iconBlock : Mark.Block View.Resource.ResourceKind
iconBlock =
    Mark.oneOf
        [ Mark.exactly "Video" View.Resource.Video
        , Mark.exactly "Library" View.Resource.Library
        , Mark.exactly "App" View.Resource.App
        , Mark.exactly "Article" View.Resource.Article
        , Mark.exactly "Exercise" View.Resource.Exercise
        , Mark.exactly "Book" View.Resource.Book
        ]


{-| A custom inline block for code. This is analagous to `backticks` in markdown.
Though, style it however you'd like.
`{Code| Here is my styled inline code block }`
-}
code : List (Element.Attribute msg) -> Mark.Inline (model -> Element msg)
code style =
    Mark.inline "Code"
        (\txt model ->
            Element.row style
                (List.map (\item -> textFragment item model) txt)
        )
        |> Mark.inlineText


{-| A custom inline block for links.
`{Link|My link text|url=http://google.com}`
-}
link : List RelativeUrl -> List (Element.Attribute msg) -> Mark.Inline (model -> Element msg)
link validRelativeUrls style =
    Mark.inline "Link"
        (\txt url model ->
            Element.link style
                { url = url
                , label =
                    Element.row [ Element.htmlAttribute (Html.Attributes.style "display" "inline-flex") ]
                        (List.map (\item -> textFragment item model) txt)
                }
        )
        |> Mark.inlineText
        |> Mark.inlineString "url"


{-| Render a text fragment.
-}
textFragment : Mark.Text -> model -> Element msg
textFragment node model_ =
    case node of
        Mark.Text styles txt ->
            Element.el (List.concatMap toStyles styles) (Element.text txt)


{-| -}
toStyles : Mark.Style -> List (Element.Attribute msg)
toStyles style =
    case style of
        Mark.Bold ->
            [ Font.bold ]

        Mark.Italic ->
            [ Font.italic ]

        Mark.Strike ->
            [ Font.strike ]


image : Mark.Block (model -> Element msg)
image =
    Mark.record2 "Image"
        (\src description model ->
            Element.image
                [ Element.width (Element.fill |> Element.maximum 600)
                , Element.centerX
                ]
                { src = src
                , description = description
                }
                |> Element.el [ Element.centerX ]
        )
        (Mark.field "src" Mark.string)
        (Mark.field "description" Mark.string)


ellie : Mark.Block (model -> Element msg)
ellie =
    Mark.block "Ellie"
        (\id model -> View.Ellie.view id)
        Mark.string


listStyles : List Int -> List (Element.Attribute msg)
listStyles cursor =
    (case List.length cursor of
        0 ->
            -- top level element
            [ Element.spacing 16 ]

        1 ->
            [ Element.spacing 16 ]

        2 ->
            [ Element.spacing 16 ]

        _ ->
            [ Element.spacing 8 ]
    )
        ++ [ Font.alignLeft, Element.width Element.fill ]

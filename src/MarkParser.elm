module MarkParser exposing (document, parse)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region
import Html
import Html.Attributes
import Mark exposing (Document)
import Mark.Default
import Parser.Advanced
import Style
import Style.Helpers
import View.CodeSnippet
import View.DripSignupForm
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
    Mark.parse document


toplevelText =
    textWith Mark.Default.defaultTextStyle


document : Mark.Document (model -> Element msg)
document =
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
            [ header
            , subHeader [ Font.size 24, Font.semiBold, Font.alignLeft, Font.family [ Font.typeface "Raleway" ] ] toplevelText
            , list
            , image
            , ellie
            , contactButton
            , resources
            , vimeo
            , signupForm
            , resource |> Mark.map (\thing model -> thing)
            , monospace
            , Mark.map (\viewEls model -> Element.paragraph [] (viewEls model)) toplevelText
            ]
        )


header =
    Mark.Default.header [ Font.size 36, Font.center, Font.family [ Font.typeface "Raleway" ], Font.bold ] toplevelText


vimeoView videoId =
    Html.iframe
        [ Html.Attributes.src <| "https://player.vimeo.com/video/" ++ videoId
        , Html.Attributes.attribute "width" "100%"
        , Html.Attributes.attribute "height" "100%"
        , Html.Attributes.attribute "allow" "autoplay; fullscreen"
        , Html.Attributes.attribute "allowfullscreen" ""
        ]
        []
        |> Element.html
        |> Element.el
            [ Element.width Element.fill
            , Element.height (Element.px 600)
            ]


list =
    Mark.Default.list
        { style = listStyles
        , icon = Mark.Default.listIcon
        }
        toplevelText


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


vimeo : Mark.Block (model -> Element msg)
vimeo =
    Mark.block "Vimeo"
        (\videoId model -> vimeoView videoId)
        Mark.string


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


signupForm : Mark.Block (model -> Element msg)
signupForm =
    Mark.block "Signup"
        (\stuff model ->
            [ Element.column
                [ Font.center
                , Element.spacing 30
                , Element.centerX
                ]
                (stuff.body |> List.map (\a -> a model))
            , View.DripSignupForm.viewNew stuff.config.buttonText stuff.config.formId { maybeReferenceId = Nothing }
                |> Element.html
                |> Element.el [ Element.width Element.fill ]
            ]
                |> Element.column
                    [ Element.width Element.fill
                    , Element.padding 20
                    , Element.spacing 20
                    , Border.shadow { offset = ( 0, 0 ), size = 1, blur = 4, color = Element.rgb 0.8 0.8 0.8 }
                    , Element.mouseOver
                        [ Border.shadow { offset = ( 0, 0 ), size = 1, blur = 4, color = Element.rgb 0.85 0.85 0.85 } ]
                    ]
        )
        (Mark.startWith (\config body -> { config = config, body = body })
            (Mark.record2 "Config"
                (\buttonText formId -> { buttonText = buttonText, formId = formId })
                (Mark.field "buttonText" Mark.string)
                (Mark.field "formId" Mark.string)
            )
            thing2
        )


thing2 : Mark.Block (List (model -> Element msg))
thing2 =
    Mark.manyOf [ header, list ]



-- |> Mark.field "buttonText"


textWith :
    { code : List (Element.Attribute msg)
    , link : List (Element.Attribute msg)
    , inlines : List (Mark.Inline (model -> Element msg))
    , replacements : List Mark.Replacement
    }
    -> Mark.Block (model -> List (Element msg))
textWith config =
    Mark.map
        (\els model ->
            List.map (\view -> view model) els
        )
        (Mark.text
            { view = textFragment
            , inlines =
                [ link config.link
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
link : List (Element.Attribute msg) -> Mark.Inline (model -> Element msg)
link style =
    Mark.inline "Link"
        (\txt url model ->
            Element.link style
                { url = url
                , label =
                    Element.paragraph []
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

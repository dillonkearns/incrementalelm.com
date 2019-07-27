module MarkupPages.Parser exposing (AppData, Metadata, PageOrPost, document, imageSrc, normalizedUrl)

import Dict exposing (Dict)
import Element exposing (Element)
import Element.Border
import Element.Font as Font
import Element.Region
import Html exposing (Html)
import Html.Attributes as Attr
import Mark
import Mark.Error
import Style
import Style.Helpers
import View.CodeSnippet
import View.DripSignupForm
import View.FontAwesome


type alias PageOrPost metadata view =
    { metadata : metadata
    , view : view
    }


normalizedUrl url =
    url
        |> String.split "#"
        |> List.head
        |> Maybe.withDefault ""


type alias Metadata msg =
    { description : String
    , title : { styled : Element msg, raw : String }
    }


type alias AppData msg =
    { imageAssets : Dict String String
    , routes : List String
    , indexView : Maybe (List ( List String, PageOrPost (Metadata msg) (List (Element msg)) ))
    }


document :
    AppData msg
    -> List (Mark.Block (Element msg))
    -> Mark.Document (PageOrPost (Metadata msg) (List (Element msg)))
document appData blocks =
    Mark.documentWith
        (\meta body ->
            { metadata = meta, view = body }
        )
        -- We have some required metadata that starts our document.
        { metadata = metadata
        , body = Mark.manyOf blocks
        }


imageSrc : AppData msg -> Mark.Block String
imageSrc { imageAssets } =
    Mark.string
        |> Mark.verify
            (\src ->
                case Dict.get src imageAssets of
                    Just hashedImagePath ->
                        Ok hashedImagePath

                    Nothing ->
                        Err
                            { title = "Could not image `" ++ src ++ "`"
                            , message =
                                [ "Must be one of\n"
                                , Dict.keys imageAssets |> String.join "\n"
                                ]
                            }
            )


metadata : Mark.Block (Metadata msg)
metadata =
    Mark.oneOf
        [ Mark.record "Article"
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
        , Mark.record "Page"
            (\title ->
                { description = title.raw
                , title = title
                }
            )
            |> Mark.field "title"
                (Mark.map
                    gather
                    titleText
                )
            |> Mark.toBlock
        ]


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

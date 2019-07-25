module MarkupPages.Parser exposing (PageOrPost, document, normalizedUrl)

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



-- type PageOrPost = Page Metadata | Post Metadat


normalizedUrl url =
    url
        |> String.split "#"
        |> List.head
        |> Maybe.withDefault ""


type alias Metadata msg =
    { description : String
    , title : { styled : Element msg, raw : String }
    }


type alias PageOrPost msg =
    { body : List (Element msg)
    , metadata : Metadata msg
    , preview : List (Element msg)
    }


type alias AppData msg =
    { imageAssets : Dict String String
    , routes : List String
    , indexView : Element msg
    }


document :
    AppData msg
    -> List (Mark.Block (Element msg))
    ->
        Mark.Document
            { body : List (Element msg)
            , metadata : Metadata msg
            , preview : List (Element msg)
            }
document appData blocks =
    Mark.documentWith
        (\meta body ->
            { metadata = meta
            , body =
                [ Element.textColumn
                    [ Element.centerX
                    , Element.width Element.fill
                    , Element.spacing 30
                    , Font.size 18
                    ]
                    body
                ]
            , preview =
                body |> List.take 2
            }
        )
        -- We have some required metadata that starts our document.
        { metadata = metadata
        , body = Mark.manyOf (image appData.imageAssets :: blocks)
        }


image : Dict String String -> Mark.Block (Element msg)
image imageAssets =
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
        |> Mark.field "src" (imageSrc imageAssets)
        |> Mark.field "description" Mark.string
        |> Mark.toBlock


imageSrc : Dict String String -> Mark.Block String
imageSrc imageAssets =
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

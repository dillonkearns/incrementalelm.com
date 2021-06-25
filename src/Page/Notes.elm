module Page.Notes exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Element
import Element.Font as Font
import Head
import Head.Seo as Seo
import List.Extra
import Markdown.Block as Block exposing (Block)
import Markdown.Parser
import OptimizedDecoder as Decode
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import Route exposing (Route)
import Serialize
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    DataSource.map Data
        wikiEntries


noteTitle : String -> DataSource String
noteTitle slug =
    DataSource.File.bodyWithoutFrontmatter ("content/glossary/" ++ slug ++ ".md")
        |> DataSource.andThen
            (\rawContent ->
                Markdown.Parser.parse rawContent
                    |> Result.mapError (\_ -> "Markdown error")
                    |> Result.map
                        (\blocks ->
                            List.Extra.findMap
                                (\block ->
                                    case block of
                                        Block.Heading Block.H1 inlines ->
                                            Just (Block.extractInlineText inlines)

                                        _ ->
                                            Nothing
                                )
                                blocks
                        )
                    |> Result.andThen (Result.fromMaybe "Expected to find an H1 heading")
                    |> DataSource.fromResult
            )
        |> DataSource.distillSerializeCodec ("note-title-" ++ slug) Serialize.string


type alias Data =
    { notes : List Note
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Incremental Elm Wiki"
    , body =
        [ Element.paragraph
            [ Font.size 36
            , Font.center
            , Font.family [ Font.typeface "Raleway" ]
            , Font.bold
            ]
            [ Element.text "Incremental Elm Wiki" ]
        , Element.column []
            (static.data.notes
                |> List.map
                    (\note ->
                        Element.link []
                            { url = Route.toPath note.route |> Path.toAbsolute
                            , label =
                                Element.el []
                                    (Element.text <| note.title ++ " #" ++ String.join ", " note.tags)
                            }
                    )
            )
        ]
    }


type alias Note =
    { route : Route
    , slug : String
    , title : String
    , tags : List String
    }


wikiEntries : DataSource (List Note)
wikiEntries =
    Glob.succeed
        (\topic filePath ->
            DataSource.map2
                (Note (Route.Notes__Topic_ { topic = topic }) topic)
                (noteTitle topic)
                (DataSource.File.onlyFrontmatter
                    (Decode.optionalField "tags"
                        (Decode.oneOf
                            [ Decode.list Decode.string
                            , Decode.string |> Decode.map List.singleton
                            ]
                        )
                        |> Decode.map (Maybe.withDefault [])
                    )
                    filePath
                )
        )
        |> Glob.match (Glob.literal "content/glossary/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.captureFilePath
        |> Glob.toDataSource
        |> DataSource.resolve


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = "Incremental Elm"
        , image =
            { url = Pages.Url.external ""
            , alt = "Incremental Elm Wiki"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Incremental Elm Wiki"
        , title = "Incremental Elm Wiki"
        , locale = Nothing
        }
        |> Seo.article
            { tags = []
            , section = Nothing
            , publishedTime = Nothing
            , modifiedTime = Nothing
            , expirationTime = Nothing
            }

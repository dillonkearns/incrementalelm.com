module Page.Notes exposing (Data, Model, Msg, Note, RouteParams, page)

import Css
import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Link
import MarkdownCodec
import OptimizedDecoder as Decode
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Route exposing (Route)
import Shared
import Tailwind.Utilities as Tw
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
        View.Tailwind
            [ div
                [ css
                    [ Tw.font_bold
                    , Tw.text_xl
                    , Tw.text_center
                    , Css.fontFamilies [ "Raleway" ]
                    ]
                ]
                [ text "Incremental Elm Notes" ]
            , ul []
                (static.data.notes
                    |> List.map
                        (\note ->
                            note.route
                                |> Link.htmlLink []
                                    (text <| note.title ++ " #" ++ String.join ", " note.tags)
                                |> List.singleton
                                |> li []
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
                (Note (Route.Page_ { page = topic }) topic)
                (MarkdownCodec.noteTitle filePath)
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
        |> Glob.match (Glob.literal "content/")
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

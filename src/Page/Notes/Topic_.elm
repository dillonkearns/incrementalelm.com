module Page.Notes.Topic_ exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.Glob as Glob
import Element exposing (Element)
import Head
import Head.Seo as Seo
import MarkdownCodec
import MarkdownRenderer
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { topic : String }


page : Page RouteParams Data
page =
    Page.prerenderedRoute
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    Glob.succeed RouteParams
        |> Glob.match (Glob.literal "content/glossary/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


data : RouteParams -> DataSource Data
data routeParams =
    let
        filePath =
            "content/glossary/" ++ routeParams.topic ++ ".md"
    in
    MarkdownCodec.withFrontmatter Data
        decoder
        MarkdownRenderer.renderer
        filePath
        |> andMap (MarkdownCodec.noteTitle filePath)


andMap dataSource =
    DataSource.map2 (|>) dataSource


type alias Data =
    { metadata : PageMetadata
    , body : List (Element Msg)
    , title : String
    }



--view :
--    List ( Pages.PagePath.PagePath Pages.PathKey, TemplateType.TemplateType )
--    -> Template.StaticPayload TemplateType.PageMetadata templateStaticData
--    -> Shared.RenderedBody
--    -> Shared.PageView Never
--view allMetadata static viewForPage =


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.title
    , body =
        --else if static.path == Pages.pages.learn.index then
        --    [ LearnIndex.view allMetadata ]
        --
        --else if static.path == Pages.pages.glossary.index then
        --    [ allMetadata
        --        |> GlossaryIndex.view
        --    ]
        --
        --else
        static.data.body
    }



--head :
--    StaticPayload TemplateType.PageMetadata ()
--    -> List (Head.Tag Pages.PathKey)
--head { metadata } =


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = "Incremental Elm"
        , image =
            { url = static.data.metadata.image |> Maybe.withDefault (Pages.Url.external "")
            , alt = static.data.title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = static.data.metadata.description |> Maybe.withDefault static.data.title
        , title = static.data.title
        , locale = Nothing
        }
        |> Seo.website


type alias PageMetadata =
    { description : Maybe String
    , image : Maybe Pages.Url.Url
    }


decoder : Decoder PageMetadata
decoder =
    Decode.map2 PageMetadata
        (Decode.maybe (Decode.field "description" Decode.string))
        (Decode.maybe (Decode.field "image" imageDecoder))


imageDecoder : Decoder Pages.Url.Url
imageDecoder =
    Decode.string
        |> Decode.map
            (\src ->
                [ "images", src ]
                    |> Path.join
                    |> Pages.Url.fromPath
            )

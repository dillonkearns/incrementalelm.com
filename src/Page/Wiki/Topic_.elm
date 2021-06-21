module Page.Wiki.Topic_ exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.Glob as Glob
import Date exposing (Date)
import Element exposing (Element)
import Element.Font as Font
import Head
import Head.Seo as Seo
import Html.Attributes as Attr
import List.NonEmpty as NonEmpty
import MarkdownCodec
import MarkdownRenderer
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Palette
import Path
import Shared
import Site
import StructuredDataHelper
import Time
import UnsplashImage exposing (UnsplashImage)
import View exposing (View)
import Widget.Signup


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
    MarkdownCodec.withFrontmatter Data
        decoder
        MarkdownRenderer.renderer
        ("content/glossary/"
            ++ routeParams.topic
            ++ ".md"
        )


type alias Data =
    { metadata : PageMetadata
    , body : List (Element Msg)
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
    { title = static.data.metadata.title
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
            , alt = static.data.metadata.title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = static.data.metadata.description |> Maybe.withDefault static.data.metadata.title
        , title = static.data.metadata.title
        , locale = Nothing
        }
        |> Seo.website


type alias PageMetadata =
    { title : String
    , description : Maybe String
    , image : Maybe Pages.Url.Url
    }


decoder =
    Decode.map3 PageMetadata
        (Decode.field "title" Decode.string)
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

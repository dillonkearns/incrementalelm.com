module Page.Articles.Slug_ exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.Glob as Glob
import Element exposing (Element)
import Element.Font as Font
import Head
import Head.Seo as Seo
import MarkdownCodec
import MarkdownRenderer
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path exposing (Path)
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { slug : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    --DataSource.succeed
    --    [ { slug = "exit-gatekeepers" }
    --    ]
    Glob.succeed RouteParams
        |> Glob.match (Glob.literal "content/articles/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


data : RouteParams -> DataSource Data
data routeParams =
    MarkdownCodec.withFrontmatter Data
        articleDecoder
        MarkdownRenderer.renderer
        ("content/articles/" ++ routeParams.slug ++ ".md")


type alias Data =
    { metadata : ArticleMetadata
    , body : List (Element Msg)
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.metadata.title
    , body =
        (static.data.metadata.title
            |> Element.text
            |> List.singleton
            |> Element.paragraph
                [ Font.size 36
                , Font.center
                , Font.family [ Font.typeface "Raleway" ]
                , Font.bold
                ]
        )
            :: (Element.image
                    [ Element.width (Element.fill |> Element.maximum 600)
                    , Element.centerX
                    ]
                    { src = static.data.metadata.coverImage |> Path.toAbsolute
                    , description = static.data.metadata.title
                    }
                    |> Element.el [ Element.centerX ]
               )
            :: static.data.body
    }


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = "Incremental Elm"
        , image =
            { url = Pages.Url.fromPath static.data.metadata.coverImage
            , alt = static.data.metadata.description
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = static.data.metadata.description
        , title = static.data.metadata.title
        , locale = Nothing
        }
        |> Seo.article
            { tags = []
            , section = Nothing
            , publishedTime = Nothing
            , modifiedTime = Nothing
            , expirationTime = Nothing
            }


articleDecoder : Decoder ArticleMetadata
articleDecoder =
    Decode.map3 ArticleMetadata
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "src"
            (Decode.string |> Decode.map (\path -> Path.join [ "images", path ]))
        )


type alias ArticleMetadata =
    { title : String
    , description : String
    , coverImage : Path
    }

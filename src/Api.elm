module Api exposing (routes)

import ApiRoute
import DataSource exposing (DataSource)
import DataSource.Glob as Glob
import Date exposing (Date)
import Html exposing (Html)
import Markdown.Renderer
import MarkdownCodec
import OptimizedDecoder as Decode
import Pages
import Path
import Route exposing (Route)
import Rss
import Site
import UnsplashImage exposing (UnsplashImage)


routes :
    DataSource (List Route)
    -> (Html Never -> String)
    -> List (ApiRoute.Done ApiRoute.Response)
routes getStaticRoutes htmlToString =
    [ ApiRoute.succeed
        (tipsFeedItems htmlToString
            |> DataSource.map
                (\feedItems ->
                    Rss.generate
                        { title = "Incremental Elm Tips"
                        , description = "Incremental Elm Consulting"
                        , url = Site.canonicalUrl ++ "/tips"
                        , lastBuildTime = Pages.builtAt
                        , generator = Just "elm-pages"
                        , items = feedItems
                        , siteUrl = Site.canonicalUrl
                        }
                )
            |> DataSource.map (\body -> { body = body })
        )
        |> ApiRoute.literal "tips"
        |> ApiRoute.slash
        |> ApiRoute.literal "feed.xml"
        |> ApiRoute.singleRoute
    ]


tipsFeedItems : (Html Never -> String) -> DataSource (List Rss.Item)
tipsFeedItems htmlToString =
    Glob.succeed
        (\slug filePath ->
            MarkdownCodec.nonDistilledWithFrontmatter
                (\metadata body ->
                    { body = body |> List.map htmlToString |> String.join ""
                    , metadata = metadata
                    , slug = slug
                    }
                )
                tipDecoder
                Markdown.Renderer.defaultHtmlRenderer
                filePath
        )
        |> Glob.match (Glob.literal "content/tips/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.captureFilePath
        |> Glob.toDataSource
        |> DataSource.resolve
        |> DataSource.map
            (\coreItems ->
                coreItems
                    |> List.map tipToFeedItem
            )


type alias TipMetadata =
    { title : String
    , description : String
    , publishedAt : Date
    , cover : UnsplashImage
    }


tipDecoder : Decode.Decoder TipMetadata
tipDecoder =
    Decode.map4 TipMetadata
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "publishAt"
            (Decode.string
                |> Decode.andThen
                    (\isoString ->
                        case Date.fromIsoString isoString of
                            Ok date ->
                                Decode.succeed date

                            Err error ->
                                Decode.fail error
                    )
            )
        )
        (Decode.optionalField "cover" UnsplashImage.decoder
            |> Decode.map (Maybe.withDefault UnsplashImage.default)
        )


tipToFeedItem :
    { body : String
    , slug : String
    , metadata : TipMetadata
    }
    -> Rss.Item
tipToFeedItem { metadata, body, slug } =
    { title = metadata.title
    , description = metadata.description
    , url = Route.Tips__Slug_ { slug = slug } |> Route.toPath |> Path.toAbsolute
    , categories = []
    , author = "Dillon Kearns"
    , pubDate = Rss.Date metadata.publishedAt
    , content = Just body
    , contentEncoded = Just body
    , enclosure = Nothing
    }

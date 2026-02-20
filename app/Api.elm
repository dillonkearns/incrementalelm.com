module Api exposing (routes)

import ApiRoute
import BackendTask exposing (BackendTask)
import BackendTask.Custom
import BackendTask.File
import BackendTask.Glob as Glob
import Date exposing (Date)
import FatalError exposing (FatalError)
import Time
import Html exposing (Html)
import Html.String
import Json.Encode
import IcalFeed
import Json.Decode as Decode
import MarkdownCodec
import MarkdownHtmlRenderer
import Route exposing (Route)
import Request
import Request.Events
import Rss
import Site
import UrlPath
import UnsplashImage exposing (UnsplashImage)


routes :
    BackendTask FatalError (List Route)
    -> (Maybe { indent : Int, newLines : Bool } -> Html Never -> String)
    -> List (ApiRoute.ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    [ ApiRoute.succeed
        (tipsFeedItems (\html -> htmlToString Nothing html)
            |> BackendTask.map
                (\feedItems ->
                    Rss.generate
                        { title = "Incremental Elm Tips"
                        , description = "Incremental Elm Consulting"
                        , url = Site.canonicalUrl ++ "/tips"
                        , lastBuildTime = feedItems.builtAt
                        , generator = Just "elm-pages"
                        , items = feedItems.items
                        , siteUrl = Site.canonicalUrl
                        }
                )
        )
        |> ApiRoute.literal "tips"
        |> ApiRoute.slash
        |> ApiRoute.literal "feed.xml"
        |> ApiRoute.single
    , ApiRoute.succeed
        (BackendTask.map
            (\events ->
                IcalFeed.feed events
            )
            (Request.staticGraphqlRequest Request.Events.selection)
        )
        |> ApiRoute.literal "live.ics"
        |> ApiRoute.single
    ]


tipsFeedItems : (Html Never -> String) -> BackendTask FatalError { items : List Rss.Item, builtAt : Time.Posix }
tipsFeedItems htmlToString =
    BackendTask.map2
        (\items builtAt -> { items = items, builtAt = builtAt })
        (tipsFeedItemsInner htmlToString)
        (BackendTask.Custom.run "now"
            Json.Encode.null
            (Decode.int |> Decode.map Time.millisToPosix)
            |> BackendTask.allowFatal
        )


tipsFeedItemsInner : (Html Never -> String) -> BackendTask FatalError (List Rss.Item)
tipsFeedItemsInner htmlToString =
    Glob.succeed
        (\slug filePath ->
            tipDecoder filePath
                |> BackendTask.andThen
                    (\maybeMetadata ->
                        case maybeMetadata of
                            Nothing ->
                                BackendTask.succeed Nothing

                            Just metadata ->
                                filePath
                                    |> MarkdownCodec.withoutFrontmatter
                                        MarkdownHtmlRenderer.renderer
                                    |> BackendTask.map
                                        (\body ->
                                            Just
                                                { body =
                                                    body
                                                        |> List.map (Html.String.toString 0)
                                                        |> String.join ""
                                                , metadata = metadata
                                                , slug = slug
                                                }
                                        )
                    )
        )
        |> Glob.match (Glob.literal "content/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.captureFilePath
        |> Glob.toBackendTask
        |> BackendTask.andThen BackendTask.combine
        |> BackendTask.map
            (\coreItems ->
                coreItems
                    |> List.filterMap identity
                    |> List.map tipToFeedItem
            )


type alias TipMetadata =
    { title : String
    , description : String
    , publishedAt : Date
    , cover : UnsplashImage
    }


tipDecoder : String -> BackendTask FatalError (Maybe TipMetadata)
tipDecoder filePath =
    filePath
        |> BackendTask.File.onlyFrontmatter
            (Decode.map2 Tuple.pair
                (Decode.maybe
                    (Decode.field
                        "publishAt"
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
                )
                (Decode.maybe (Decode.field "cover" UnsplashImage.decoder)
                    |> Decode.map (Maybe.withDefault UnsplashImage.default)
                )
            )
        |> BackendTask.allowFatal
        |> BackendTask.andThen
            (\( maybePublishAt, cover ) ->
                case maybePublishAt of
                    Just publishAt ->
                        MarkdownCodec.titleAndDescription filePath
                            |> BackendTask.map
                                (\{ title, description } ->
                                    Just
                                        { title = title
                                        , description = description
                                        , publishedAt = publishAt
                                        , cover = cover
                                        }
                                )

                    Nothing ->
                        BackendTask.succeed Nothing
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
    , url = Route.Page_ { page = slug } |> Route.toPath |> UrlPath.toAbsolute
    , categories = []
    , author = "Dillon Kearns"
    , pubDate = Rss.Date metadata.publishedAt
    , content = Just body
    , contentEncoded = Just body
    , enclosure = Nothing
    }

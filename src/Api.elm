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
    -> List (ApiRoute.ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    [ --ApiRoute.succeed
      --   (tipsFeedItems htmlToString
      --       |> DataSource.map
      --           (\feedItems ->
      --               Rss.generate
      --                   { title = "Incremental Elm Tips"
      --                   , description = "Incremental Elm Consulting"
      --                   , url = Site.canonicalUrl ++ "/tips"
      --                   , lastBuildTime = Pages.builtAt
      --                   , generator = Just "elm-pages"
      --                   , items = feedItems
      --                   , siteUrl = Site.canonicalUrl
      --                   }
      --           )
      --       |> DataSource.map (\body -> { body = body })
      --   )
      --   |> ApiRoute.literal "tips"
      --   |> ApiRoute.slash
      --   |> ApiRoute.literal "feed.xml"
      --   |> ApiRoute.single
      ApiRoute.succeed
        (DataSource.succeed { body = "Hi there!" })
        --(DataSource.fail "Fail from API")
        |> ApiRoute.literal "hello.txt"
        |> ApiRoute.single
    ]


tipsFeedItems : (Html Never -> String) -> DataSource (List Rss.Item)
tipsFeedItems htmlToString =
    Glob.succeed
        (\slug filePath ->
            MarkdownCodec.withFrontmatter
                (\maybeMetadata body ->
                    maybeMetadata
                        |> Maybe.map
                            (\metadata ->
                                { body = body |> List.map htmlToString |> String.join ""
                                , metadata = metadata
                                , slug = slug
                                }
                            )
                )
                tipDecoder
                Markdown.Renderer.defaultHtmlRenderer
                filePath
        )
        |> Glob.match (Glob.literal "content/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.captureFilePath
        |> Glob.toDataSource
        |> DataSource.resolve
        |> DataSource.map
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


tipDecoder : Decode.Decoder (Maybe TipMetadata)
tipDecoder =
    Decode.optionalField "publishAt"
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
        |> Decode.andThen
            (\maybePublishAt ->
                case maybePublishAt of
                    Just publishAt ->
                        Decode.map3
                            (\title description cover ->
                                TipMetadata
                                    title
                                    description
                                    publishAt
                                    cover
                                    |> Just
                            )
                            (Decode.field "title" Decode.string)
                            (Decode.field "description" Decode.string)
                            (Decode.optionalField "cover" UnsplashImage.decoder
                                |> Decode.map (Maybe.withDefault UnsplashImage.default)
                            )

                    Nothing ->
                        Decode.succeed Nothing
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



--
--metadataToRssItem :
--    { path : PagePath Pages.PathKey
--    , frontmatter : TemplateType
--    , body : String
--    }
--    -> Maybe (Result String Rss.Item)
--metadataToRssItem page =
--    case page.frontmatter of
--        TemplateType.Tip tip ->
--            page.body
--                |> MarkdownToHtmlStringRenderer.renderMarkdown
--                |> Result.map
--                    (\markdownHtmlString ->
--                        { title = tip.title
--                        , description = tip.description
--                        , url = PagePath.toString page.path
--                        , categories = []
--                        , author = "Dillon Kearns"
--                        , pubDate = Rss.Date tip.publishedAt
--                        , content = Just markdownHtmlString
--                        , contentEncoded = Just markdownHtmlString
--                        , enclosure = Nothing
--                        }
--                    )
--                |> Just
--
--        _ ->
--            Nothing
--
--
--thing =
--    \_ ->
--        StaticHttp.map
--            (\events ->
--                [ Ok
--                    { path = [ "live.ics" ]
--                    , content = IcalFeed.feed events
--                    }
--                , events
--                    |> List.sortBy
--                        (\event ->
--                            Time.posixToMillis event.startsAt
--                        )
--                    |> List.reverse
--                    |> List.head
--                    |> Maybe.map
--                        (\upcoming ->
--                            UpcomingEvent.json upcoming
--                        )
--                    |> (\json ->
--                            case json of
--                                Just value ->
--                                    Ok value
--
--                                Nothing ->
--                                    Err "No upcoming events found."
--                       )
--                ]
--            )
--            (Request.staticGraphqlRequest Request.Events.selection)
--
--
--rssFeed =
--    RssPlugin.generate
--        { siteTagline = Site.tagline
--        , siteUrl = Site.canonicalUrl
--        , title = "Incremental Elm Tips"
--        , builtAt = Pages.builtAt
--        , indexPage = Pages.pages.tips
--        , now = Pages.builtAt
--        }
--        metadataToRssItem
{-

   module Main exposing (main)

   import IcalFeed
   import MarkdownRenderer
   import MarkdownToHtmlStringRenderer
   import Pages
   import Pages.PagePath as PagePath exposing (PagePath)
   import Pages.Platform exposing (Page)
   import Pages.StaticHttp as StaticHttp
   import Request
   import Request.Events exposing (LiveStream)
   import Rss
   import RssPlugin
   import Site
   import TemplateModulesBeta
   import TemplateType exposing (TemplateType)
   import Time
   import UpcomingEvent



   --main : Pages.Platform.Program Model Msg TemplateType (List (Element Msg))


   main =
       TemplateModulesBeta.mainTemplate
           { documents =
               [ { extension = "md"
                 , metadata = TemplateType.decoder
                 , body = MarkdownRenderer.view
                 }
               ]
           , site = Site.config
           }
           |> Pages.Platform.withFileGenerator
               (\_ ->
                   StaticHttp.map
                       (\events ->
                           [ Ok
                               { path = [ "live.ics" ]
                               , content = IcalFeed.feed events
                               }
                           , events
                               |> List.sortBy
                                   (\event ->
                                       Time.posixToMillis event.startsAt
                                   )
                               |> List.reverse
                               |> List.head
                               |> Maybe.map
                                   (\upcoming ->
                                       UpcomingEvent.json upcoming
                                   )
                               |> (\json ->
                                       case json of
                                           Just value ->
                                               Ok value

                                           Nothing ->
                                               Err "No upcoming events found."
                                  )
                           ]
                       )
                       (Request.staticGraphqlRequest Request.Events.selection)
               )
           |> RssPlugin.generate
               { siteTagline = Site.tagline
               , siteUrl = Site.canonicalUrl
               , title = "Incremental Elm Tips"
               , builtAt = Pages.builtAt
               , indexPage = Pages.pages.tips
               , now = Pages.builtAt
               }
               metadataToRssItem
           |> Pages.Platform.toProgram


   metadataToRssItem :
       { path : PagePath Pages.PathKey
       , frontmatter : TemplateType
       , body : String
       }
       -> Maybe (Result String Rss.Item)
   metadataToRssItem page =
       case page.frontmatter of
           TemplateType.Tip tip ->
               page.body
                   |> MarkdownToHtmlStringRenderer.renderMarkdown
                   |> Result.map
                       (\markdownHtmlString ->
                           { title = tip.title
                           , description = tip.description
                           , url = PagePath.toString page.path
                           , categories = []
                           , author = "Dillon Kearns"
                           , pubDate = Rss.Date tip.publishedAt
                           , content = Just markdownHtmlString
                           , contentEncoded = Just markdownHtmlString
                           , enclosure = Nothing
                           }
                       )
                   |> Just

           _ ->
               Nothing


   ensureAtPrefix : String -> String
   ensureAtPrefix twitterUsername =
       if twitterUsername |> String.startsWith "@" then
           twitterUsername

       else
           "@" ++ twitterUsername


   fullyQualifiedUrl : String -> String
   fullyQualifiedUrl url =
       let
           urlWithoutLeadingSlash =
               if url |> String.startsWith "/" then
                   url |> String.dropLeft 1

               else
                   url
       in
       "https://incrementalelm.com" ++ url


   siteName =
       "Incremental Elm Consulting"


-}

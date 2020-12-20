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

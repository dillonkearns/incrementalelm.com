module RssPlugin exposing (generate)

import Date
import Head
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Platform exposing (Builder)
import Pages.StaticHttp as StaticHttp
import Rss exposing (DateOrTime)
import Time exposing (customZone)


generate :
    { siteTagline : String
    , siteUrl : String
    , title : String
    , builtAt : Time.Posix
    , indexPage : PagePath pathKey
    , now : Time.Posix
    }
    ->
        ({ path : PagePath pathKey
         , frontmatter : metadata
         , body : String
         }
         -> Maybe Rss.Item
        )
    -> Builder pathKey userModel userMsg metadata view
    -> Builder pathKey userModel userMsg metadata view
generate options metadataToRssItem builder =
    let
        feedFilePath =
            (options.indexPage
                |> PagePath.toPath
            )
                ++ [ "feed.xml" ]
    in
    builder
        |> Pages.Platform.withFileGenerator
            (\siteMetadata ->
                { path = feedFilePath
                , content =
                    Rss.generate
                        { title = options.title
                        , description = options.siteTagline
                        , url = options.siteUrl ++ "/" ++ PagePath.toString options.indexPage
                        , lastBuildTime = options.builtAt
                        , generator = Just "elm-pages"
                        , items =
                            siteMetadata
                                |> List.filterMap metadataToRssItem
                                |> publishedEntries options.now
                        , siteUrl = options.siteUrl
                        }
                }
                    |> Ok
                    |> List.singleton
                    |> StaticHttp.succeed
            )
        |> Pages.Platform.withGlobalHeadTags [ Head.rssLink (feedFilePath |> String.join "/") ]


publishedEntries : Time.Posix -> List Rss.Item -> List Rss.Item
publishedEntries now =
    List.filter (\item -> hasFuturePublishDate now item.pubDate)


hasFuturePublishDate : Time.Posix -> DateOrTime -> Bool
hasFuturePublishDate now dateOrTime =
    case dateOrTime of
        Rss.Date publishDate ->
            -- now > publishDate
            Date.compare (Date.fromPosix Time.utc now) publishDate == GT

        Rss.DateTime publishDateTime ->
            -- now > publishDateTime
            Date.compare (Date.fromPosix Time.utc now) (Date.fromPosix Time.utc publishDateTime) == GT

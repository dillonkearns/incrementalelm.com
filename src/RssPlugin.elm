module RssPlugin exposing (generate)

import Date
import Head
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Platform exposing (Builder)
import Pages.StaticHttp as StaticHttp
import Result.Extra
import Rss exposing (DateOrTime)
import Time


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
         -> Maybe (Result String Rss.Item)
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
                siteMetadata
                    |> List.filterMap metadataToRssItem
                    |> Result.Extra.combine
                    |> Result.map
                        (\values ->
                            { path = feedFilePath
                            , content =
                                Rss.generate
                                    { title = options.title
                                    , description = options.siteTagline
                                    , url = options.siteUrl ++ "/" ++ PagePath.toString options.indexPage
                                    , lastBuildTime = options.builtAt
                                    , generator = Just "elm-pages"
                                    , items =
                                        values
                                            |> publishedEntries options.now
                                    , siteUrl = options.siteUrl
                                    }
                            }
                        )
                    |> List.singleton
                    |> StaticHttp.succeed
            )
        |> Pages.Platform.withGlobalHeadTags [ Head.rssLink (feedFilePath |> String.join "/") ]


publishedEntries : Time.Posix -> List Rss.Item -> List Rss.Item
publishedEntries now =
    List.filter (\item -> onOrAfterPublishDate now item.pubDate)



--isAfterPublishDate : Time.Posix -> DateOrTime -> Bool
--isAfterPublishDate now dateOrTime =
--    let
--        zone =
--            Time.utc
--    in
--    case dateOrTime of
--        Rss.Date publishDate ->
--            -- now > publishDate
--            Date.compare (Date.fromPosix zone now |> Debug.log "date") publishDate == GT
--
--        Rss.DateTime publishDateTime ->
--            -- now > publishDateTime
--            Date.compare (Date.fromPosix zone now) (Date.fromPosix zone publishDateTime) == GT


onOrAfterPublishDate : Time.Posix -> DateOrTime -> Bool
onOrAfterPublishDate now dateOrTime =
    let
        zone =
            Time.utc
    in
    case dateOrTime of
        Rss.Date publishDate ->
            -- now > publishDate
            Date.compare (Date.fromPosix zone now) publishDate /= LT

        Rss.DateTime publishDateTime ->
            -- now > publishDateTime
            Date.compare (Date.fromPosix zone now) (Date.fromPosix zone publishDateTime) /= LT

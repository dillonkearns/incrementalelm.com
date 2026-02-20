module Site exposing (canonicalUrl, config)

import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import SiteConfig exposing (SiteConfig)


config : SiteConfig
config =
    { canonicalUrl = canonicalUrl
    , head = head
    }


canonicalUrl : String
canonicalUrl =
    "https://incrementalelm.com"


head : BackendTask FatalError (List Head.Tag)
head =
    [ Head.sitemapLink "/sitemap.xml"
    ]
        |> BackendTask.succeed

module Site exposing (Data, canonicalUrl, config)

import DataSource exposing (DataSource)
import Head
import Pages.Manifest as Manifest
import Route
import SiteConfig exposing (SiteConfig)


type alias Data =
    ()


config : SiteConfig
config =
    { canonicalUrl = canonicalUrl
    , head = head
    }


canonicalUrl : String
canonicalUrl =
    "https://incrementalelm.com"


head : DataSource (List Head.Tag)
head =
    [ Head.sitemapLink "/sitemap.xml"
    ]
        |> DataSource.succeed


manifest : Data -> Manifest.Config
manifest _ =
    Manifest.init
        { name = "Site Name"
        , description = "Description"
        , startUrl = Route.toPath Route.Index
        , icons = []
        }

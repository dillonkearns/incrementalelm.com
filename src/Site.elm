module Site exposing (Data, canonicalUrl, config)

import DataSource
import Head
import Pages.Manifest as Manifest
import Route
import SiteConfig exposing (SiteConfig)


type alias Data =
    ()


config : SiteConfig Data
config =
    \_ ->
        { data = data
        , canonicalUrl = canonicalUrl
        , manifest = manifest
        , head = head
        }


canonicalUrl : String
canonicalUrl =
    "https://incrementalelm.com"


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


head : Data -> List Head.Tag
head static =
    [ Head.sitemapLink "/sitemap.xml"
    ]


manifest : Data -> Manifest.Config
manifest static =
    Manifest.init
        { name = "Site Name"
        , description = "Description"
        , startUrl = Route.toPath Route.Index
        , icons = []
        }

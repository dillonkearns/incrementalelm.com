module Site exposing (..)

import Color
import Pages
import Pages.Manifest as Manifest
import Pages.Manifest.Category


config =
    { canonicalUrl = canonicalUrl
    , manifest = manifest
    }


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.MinimalUi
    , orientation = Manifest.Portrait
    , description = siteTagline
    , iarcRatingId = Nothing
    , name = "Incremental Elm Consulting"
    , themeColor = Just Color.white
    , startUrl = Pages.pages.index
    , shortName = Just "Incremental Elm"
    , sourceIcon = Pages.images.iconPng
    }


siteTagline =
    "Incremental Elm Consulting"


canonicalUrl : String
canonicalUrl =
    "https://incrementalelm.com"

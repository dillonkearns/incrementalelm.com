port module Pages exposing (PathKey, allPages, allImages, internals, images, isValidRoute, pages, builtAt)

import Color exposing (Color)
import Pages.Internal
import Head
import Html exposing (Html)
import Json.Decode
import Json.Encode
import Mark
import Pages.Platform
import Pages.Manifest exposing (DisplayMode, Orientation)
import Pages.Manifest.Category as Category exposing (Category)
import Url.Parser as Url exposing ((</>), s)
import Pages.Document as Document
import Pages.ImagePath as ImagePath exposing (ImagePath)
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Directory as Directory exposing (Directory)
import Time


builtAt : Time.Posix
builtAt =
    Time.millisToPosix 1578635417

type PathKey
    = PathKey


buildImage : List String -> ImagePath PathKey
buildImage path =
    ImagePath.build PathKey ("images" :: path)



buildPage : List String -> PagePath PathKey
buildPage path =
    PagePath.build PathKey path


directoryWithIndex : List String -> Directory PathKey Directory.WithIndex
directoryWithIndex path =
    Directory.withIndex PathKey allPages path


directoryWithoutIndex : List String -> Directory PathKey Directory.WithoutIndex
directoryWithoutIndex path =
    Directory.withoutIndex PathKey allPages path


port toJsPort : Json.Encode.Value -> Cmd msg


internals : Pages.Internal.Internal PathKey
internals =
    { applicationType = Pages.Internal.Browser
    , toJsPort = toJsPort
    , content = content
    , pathKey = PathKey
    }
        



allPages : List (PagePath PathKey)
allPages =
    [ (buildPage [ "articles", "exit-gatekeepers" ])
    , (buildPage [ "articles" ])
    , (buildPage [  ])
    , (buildPage [ "learn" ])
    , (buildPage [ "tips" ])
    ]

pages =
    { articles =
        { exitGatekeepers = (buildPage [ "articles", "exit-gatekeepers" ])
        , index = (buildPage [ "articles" ])
        , directory = directoryWithIndex ["articles"]
        }
    , index = (buildPage [  ])
    , learn =
        { index = (buildPage [ "learn" ])
        , directory = directoryWithIndex ["learn"]
        }
    , tips = (buildPage [ "tips" ])
    , directory = directoryWithIndex []
    }

images =
    { architecture = (buildImage [ "architecture.jpg" ])
    , articleCover =
        { exit = (buildImage [ "article-cover", "exit.jpg" ])
        , mountains = (buildImage [ "article-cover", "mountains.jpg" ])
        , thinker = (buildImage [ "article-cover", "thinker.jpg" ])
        , directory = directoryWithoutIndex ["articleCover"]
        }
    , buildrCropped = (buildImage [ "buildr-cropped.jpg" ])
    , contact = (buildImage [ "contact.jpg" ])
    , customScalarChecklist = (buildImage [ "custom-scalar-checklist.pdf" ])
    , dillon = (buildImage [ "dillon.jpg" ])
    , dillon2 = (buildImage [ "dillon2.jpg" ])
    , edGonzalez = (buildImage [ "ed-gonzalez.png" ])
    , elmGraphqlWorkshopHeader = (buildImage [ "elm-graphql-workshop-header.jpg" ])
    , graphqlWorkshop = (buildImage [ "graphql-workshop.png" ])
    , iconPng = (buildImage [ "icon-png.png" ])
    , icon = (buildImage [ "icon.svg" ])
    , osloWorkshop1 = (buildImage [ "oslo-workshop1.jpg" ])
    , steps = (buildImage [ "steps.jpg" ])
    , workspace = (buildImage [ "workspace.jpg" ])
    , directory = directoryWithoutIndex []
    }

allImages : List (ImagePath PathKey)
allImages =
    [(buildImage [ "architecture.jpg" ])
    , (buildImage [ "article-cover", "exit.jpg" ])
    , (buildImage [ "article-cover", "mountains.jpg" ])
    , (buildImage [ "article-cover", "thinker.jpg" ])
    , (buildImage [ "buildr-cropped.jpg" ])
    , (buildImage [ "contact.jpg" ])
    , (buildImage [ "custom-scalar-checklist.pdf" ])
    , (buildImage [ "dillon.jpg" ])
    , (buildImage [ "dillon2.jpg" ])
    , (buildImage [ "ed-gonzalez.png" ])
    , (buildImage [ "elm-graphql-workshop-header.jpg" ])
    , (buildImage [ "graphql-workshop.png" ])
    , (buildImage [ "icon-png.png" ])
    , (buildImage [ "icon.svg" ])
    , (buildImage [ "oslo-workshop1.jpg" ])
    , (buildImage [ "steps.jpg" ])
    , (buildImage [ "workspace.jpg" ])
    ]


isValidRoute : String -> Result String ()
isValidRoute route =
    let
        validRoutes =
            List.map PagePath.toString allPages
    in
    if
        (route |> String.startsWith "http://")
            || (route |> String.startsWith "https://")
            || (route |> String.startsWith "#")
            || (validRoutes |> List.member route)
    then
        Ok ()

    else
        ("Valid routes:\n"
            ++ String.join "\n\n" validRoutes
        )
            |> Err


content : List ( List String, { extension: String, frontMatter : String, body : Maybe String } )
content =
    [ 
  ( []
    , { frontMatter = """{"type":"page","title":"Incremental Elm Consulting"}
""" , body = Nothing
    , extension = "md"
    } )
  ,
  ( ["tips"]
    , { frontMatter = """{"type":"page","title":"Weekly elm Tips!"}
""" , body = Nothing
    , extension = "md"
    } )
  ,
  ( ["articles", "exit-gatekeepers"]
    , { frontMatter = """{"type":"article","title":"Using elm types to prevent logging social security #'s","src":"article-cover/exit.jpg","description":"One of the most successful techniques I've seen for making sure you don't break elm code the next time you touch it is a technique I call an *Exit Gatekeeper*."}
""" , body = Nothing
    , extension = "md"
    } )
  ,
  ( ["articles"]
    , { frontMatter = """{"type":"page"}
""" , body = Nothing
    , extension = "md"
    } )
  ,
  ( ["learn"]
    , { frontMatter = """{"type":"page","title":"Learning Resources"}
""" , body = Nothing
    , extension = "md"
    } )
  
    ]

port module PagesNew exposing (PathKey, allPages, allImages, application, images, isValidRoute, pages)

import Dict exposing (Dict)
import Color exposing (Color)
import Head
import Html exposing (Html)
import Json.Decode
import Json.Encode
import Mark
import Pages
import Pages.ContentCache exposing (Page)
import Pages.Manifest exposing (DisplayMode, Orientation)
import Pages.Manifest.Category as Category exposing (Category)
import Url.Parser as Url exposing ((</>), s)
import Pages.Document
import Pages.Path as Path exposing (Path)


type PathKey
    = PathKey


buildImage : List String -> Path PathKey Path.ToImage
buildImage path =
    Path.buildImage PathKey ("images" :: path)



buildPage : List String -> Path PathKey Path.ToPage
buildPage path =
    Path.buildPage PathKey path
port toJsPort : Json.Encode.Value -> Cmd msg


application :
    { init : ( userModel, Cmd userMsg )
    , update : userMsg -> userModel -> ( userModel, Cmd userMsg )
    , subscriptions : userModel -> Sub userMsg
    , view : userModel -> List ( List String, metadata ) -> Page metadata view -> { title : String, body : Html userMsg }
    , head : metadata -> List (Head.Tag PathKey)
    , documents : List (Pages.Document.DocumentParser metadata view)
    , manifest : Pages.Manifest.Config PathKey
    , canonicalSiteUrl : String
    }
    -> Pages.Program userModel userMsg metadata view
application config =
    Pages.application
        { init = config.init
        , view = config.view
        , update = config.update
        , subscriptions = config.subscriptions
        , document = Dict.fromList config.documents
        , content = content
        , toJsPort = toJsPort
        , head = config.head
        , manifest = config.manifest
        , canonicalSiteUrl = config.canonicalSiteUrl
        }



allPages : List (Path PathKey Path.ToPage)
allPages =
    [ (buildPage [ "accelerator-application" ])
    , (buildPage [ "accelerator-program" ])
    , (buildPage [ "articles", "exit-gatekeepers" ])
    , (buildPage [ "articles" ])
    , (buildPage [ "articles", "moving-faster-with-tiny-steps" ])
    , (buildPage [ "articles", "to-test-or-not-to-test" ])
    , (buildPage [ "contact" ])
    , (buildPage [ "core-skills-seminar" ])
    , (buildPage [ "custom-scalar-checklist" ])
    , (buildPage [ "elm-graphql-seminar" ])
    , (buildPage [ "elm-graphql-workshop" ])
    , (buildPage [ "incremental-weekly-unsubscribe" ])
    , (buildPage [  ])
    , (buildPage [ "introducing-custom-scalars-course" ])
    , (buildPage [ "learn", "architecture" ])
    , (buildPage [ "learn", "editor-config" ])
    , (buildPage [ "learn", "getting-started" ])
    , (buildPage [ "learn" ])
    , (buildPage [ "scalar-codecs-tutorial" ])
    , (buildPage [ "services" ])
    , (buildPage [ "thank-you" ])
    , (buildPage [ "tips" ])
    ]

pages =
    { acceleratorApplication = (buildPage [ "accelerator-application" ])
    , acceleratorProgram = (buildPage [ "accelerator-program" ])
    , articles =
        { exitGatekeepers = (buildPage [ "articles", "exit-gatekeepers" ])
        , index = (buildPage [ "articles" ])
        , movingFasterWithTinySteps = (buildPage [ "articles", "moving-faster-with-tiny-steps" ])
        , toTestOrNotToTest = (buildPage [ "articles", "to-test-or-not-to-test" ])
        , all = [ (buildPage [ "articles", "exit-gatekeepers" ]), (buildPage [ "articles" ]), (buildPage [ "articles", "moving-faster-with-tiny-steps" ]), (buildPage [ "articles", "to-test-or-not-to-test" ]) ]
        }
    , contact = (buildPage [ "contact" ])
    , coreSkillsSeminar = (buildPage [ "core-skills-seminar" ])
    , customScalarChecklist = (buildPage [ "custom-scalar-checklist" ])
    , elmGraphqlSeminar = (buildPage [ "elm-graphql-seminar" ])
    , elmGraphqlWorkshop = (buildPage [ "elm-graphql-workshop" ])
    , incrementalWeeklyUnsubscribe = (buildPage [ "incremental-weekly-unsubscribe" ])
    , index = (buildPage [  ])
    , introducingCustomScalarsCourse = (buildPage [ "introducing-custom-scalars-course" ])
    , learn =
        { architecture = (buildPage [ "learn", "architecture" ])
        , editorConfig = (buildPage [ "learn", "editor-config" ])
        , gettingStarted = (buildPage [ "learn", "getting-started" ])
        , index = (buildPage [ "learn" ])
        , all = [ (buildPage [ "learn", "architecture" ]), (buildPage [ "learn", "editor-config" ]), (buildPage [ "learn", "getting-started" ]), (buildPage [ "learn" ]) ]
        }
    , scalarCodecsTutorial = (buildPage [ "scalar-codecs-tutorial" ])
    , services = (buildPage [ "services" ])
    , thankYou = (buildPage [ "thank-you" ])
    , tips = (buildPage [ "tips" ])
    , all = [ (buildPage [ "accelerator-application" ]), (buildPage [ "accelerator-program" ]), (buildPage [ "contact" ]), (buildPage [ "core-skills-seminar" ]), (buildPage [ "custom-scalar-checklist" ]), (buildPage [ "elm-graphql-seminar" ]), (buildPage [ "elm-graphql-workshop" ]), (buildPage [ "incremental-weekly-unsubscribe" ]), (buildPage [  ]), (buildPage [ "introducing-custom-scalars-course" ]), (buildPage [ "scalar-codecs-tutorial" ]), (buildPage [ "services" ]), (buildPage [ "thank-you" ]), (buildPage [ "tips" ]) ]
    }

images =
    { architecture = (buildImage [ "architecture.jpg" ])
    , articleCover =
        { exit = (buildImage [ "article-cover", "exit.jpg" ])
        , mountains = (buildImage [ "article-cover", "mountains.jpg" ])
        , thinker = (buildImage [ "article-cover", "thinker.jpg" ])
        , all = [ (buildImage [ "article-cover", "exit.jpg" ]), (buildImage [ "article-cover", "mountains.jpg" ]), (buildImage [ "article-cover", "thinker.jpg" ]) ]
        }
    , buildrCropped = (buildImage [ "buildr-cropped.jpg" ])
    , contact = (buildImage [ "contact.jpg" ])
    , customScalarChecklist = (buildImage [ "custom-scalar-checklist.pdf" ])
    , dillon = (buildImage [ "dillon.jpg" ])
    , dillon2 = (buildImage [ "dillon2.jpg" ])
    , edGonzalez = (buildImage [ "ed-gonzalez.png" ])
    , elmGraphqlWorkshopHeader = (buildImage [ "elm-graphql-workshop-header.jpg" ])
    , graphqlWorkshop = (buildImage [ "graphql-workshop.png" ])
    , icon = (buildImage [ "icon.svg" ])
    , osloWorkshop1 = (buildImage [ "oslo-workshop1.jpg" ])
    , steps = (buildImage [ "steps.jpg" ])
    , workspace = (buildImage [ "workspace.jpg" ])
    , all = [ (buildImage [ "architecture.jpg" ]), (buildImage [ "buildr-cropped.jpg" ]), (buildImage [ "contact.jpg" ]), (buildImage [ "custom-scalar-checklist.pdf" ]), (buildImage [ "dillon.jpg" ]), (buildImage [ "dillon2.jpg" ]), (buildImage [ "ed-gonzalez.png" ]), (buildImage [ "elm-graphql-workshop-header.jpg" ]), (buildImage [ "graphql-workshop.png" ]), (buildImage [ "icon.svg" ]), (buildImage [ "oslo-workshop1.jpg" ]), (buildImage [ "steps.jpg" ]), (buildImage [ "workspace.jpg" ]) ]
    }

allImages : List (Path PathKey Path.ToImage)
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
    , (buildImage [ "icon.svg" ])
    , (buildImage [ "oslo-workshop1.jpg" ])
    , (buildImage [ "steps.jpg" ])
    , (buildImage [ "workspace.jpg" ])
    ]


isValidRoute : String -> Result String ()
isValidRoute route =
    let
        validRoutes =
            List.map Path.toString allPages
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
  ( ["accelerator-application"]
    , { frontMatter = """
|> Page
    title = Accelerator Application
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["accelerator-program"]
    , { frontMatter = """
|> Page
    title = Elm Accelerator Group Coaching Program
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["articles", "exit-gatekeepers"]
    , { frontMatter = """
|> Article
    title = Using elm types to prevent logging social security #'s
    src = article-cover/exit.jpg
    description = One of the most successful techniques I've seen for making sure you don't break elm code the next time you touch it is a technique I call an *Exit Gatekeeper*.
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["articles"]
    , { frontMatter = """
|> Page
    title = Articles
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["articles", "moving-faster-with-tiny-steps"]
    , { frontMatter = """
|> Article
    title = Moving Faster with Tiny Steps in Elm
    src = article-cover/mountains.jpg
    description = In this post, we're going to be looking up an Article in an Elm Dict, using the tiniest steps possible.
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["articles", "to-test-or-not-to-test"]
    , { frontMatter = """
|> Article
    title = To test, or not to test elm code?
    src = article-cover/thinker.jpg
    description = Is it as simple as "only test your business logic?"
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["contact"]
    , { frontMatter = """
|> Page
    title = Contact
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["core-skills-seminar"]
    , { frontMatter = """
|> Page
    title = Core Skills Seminar
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["custom-scalar-checklist"]
    , { frontMatter = """
|> Page
    title = Custom Scalar Checklist
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["elm-graphql-seminar"]
    , { frontMatter = """
|> Page
    title = Elm GraphQL Seminar
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["elm-graphql-workshop"]
    , { frontMatter = """
|> Page
    title = Elm GraphQL Workshop
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["incremental-weekly-unsubscribe"]
    , { frontMatter = """
|> Page
    title = Incremental Elm Weekly Unsubscribe
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( []
    , { frontMatter = """
|> Page
    title = Incremental Elm Consulting
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["introducing-custom-scalars-course"]
    , { frontMatter = """
|> Page
    title = Introducing Custom Scalars to your Codebase
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["learn", "architecture"]
    , { frontMatter = """
|> Learn
    title = The Elm Architecture
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["learn", "editor-config"]
    , { frontMatter = """
|> Learn
    title = Recommended Editor Configuration
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["learn", "getting-started"]
    , { frontMatter = """
|> Learn
    title = Getting Started Resources
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["learn"]
    , { frontMatter = """
|> Page
    title = Learning Resources
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["scalar-codecs-tutorial"]
    , { frontMatter = """
|> Page
    title = elm-graphql - Scalar Codecs Tutorial
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["services"]
    , { frontMatter = """
|> Page
    title = Incremental Elm Services
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["thank-you"]
    , { frontMatter = """
|> Page
    title = Sign up confirmation
""" , body = Nothing
    , extension = "emu"
    } )
  ,
  ( ["tips"]
    , { frontMatter = """
|> Page
    title = Weekly elm Tips!
""" , body = Nothing
    , extension = "emu"
    } )
  
    ]

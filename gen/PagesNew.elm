port module PagesNew exposing (application, PageRoute, all, pages, routeToString, Image, imageUrl, images, allImages)

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
import RawContent
import Url.Parser as Url exposing ((</>), s)
import Pages.Document


port toJsPort : Json.Encode.Value -> Cmd msg


application :
    { init : ( userModel, Cmd userMsg )
    , update : userMsg -> userModel -> ( userModel, Cmd userMsg )
    , subscriptions : userModel -> Sub userMsg
    , view : userModel -> List ( List String, metadata ) -> Page metadata view -> { title : String, body : Html userMsg }
    , head : metadata -> List Head.Tag
    , documents : List (Pages.Document.DocumentParser metadata view)
    , manifest :
        { backgroundColor : Maybe Color
        , categories : List Category
        , displayMode : DisplayMode
        , orientation : Orientation
        , description : String
        , iarcRatingId : Maybe String
        , name : String
        , themeColor : Maybe Color
        , startUrl : PageRoute
        , shortName : Maybe String
        , sourceIcon : Image
        }
    }
    -> Pages.Program userModel userMsg metadata view
application config =
    Pages.application
        { init = config.init
        , view = config.view
        , update = config.update
        , subscriptions = config.subscriptions
        , document = Dict.fromList config.documents
        , content = RawContent.content
        , toJsPort = toJsPort
        , head = config.head
        , manifest =
            { backgroundColor = config.manifest.backgroundColor
            , categories = config.manifest.categories
            , displayMode = config.manifest.displayMode
            , orientation = config.manifest.orientation
            , description = config.manifest.description
            , iarcRatingId = config.manifest.iarcRatingId
            , name = config.manifest.name
            , themeColor = config.manifest.themeColor
            , startUrl = Just (routeToString config.manifest.startUrl)
            , shortName = config.manifest.shortName
            , sourceIcon = "./" ++ imageUrl config.manifest.sourceIcon
            }
        }


type PageRoute = PageRoute (List String)

type Image = Image (List String)

imageUrl : Image -> String
imageUrl (Image path) =
    "/"
        ++ String.join "/" ("images" :: path)

all : List PageRoute
all =
    [ (PageRoute [ "accelerator-application" ])
    , (PageRoute [ "accelerator-program" ])
    , (PageRoute [ "articles", "exit-gatekeepers" ])
    , (PageRoute [ "articles" ])
    , (PageRoute [ "articles", "moving-faster-with-tiny-steps" ])
    , (PageRoute [ "articles", "to-test-or-not-to-test" ])
    , (PageRoute [ "contact" ])
    , (PageRoute [ "core-skills-seminar" ])
    , (PageRoute [ "custom-scalar-checklist" ])
    , (PageRoute [ "elm-graphql-seminar" ])
    , (PageRoute [ "elm-graphql-workshop" ])
    , (PageRoute [ "incremental-weekly-unsubscribe" ])
    , (PageRoute [  ])
    , (PageRoute [ "introducing-custom-scalars-course" ])
    , (PageRoute [ "learn", "architecture" ])
    , (PageRoute [ "learn", "editor-config" ])
    , (PageRoute [ "learn", "getting-started" ])
    , (PageRoute [ "learn" ])
    , (PageRoute [ "scalar-codecs-tutorial" ])
    , (PageRoute [ "services" ])
    , (PageRoute [ "thank-you" ])
    , (PageRoute [ "tips" ])
    ]

pages =
    { acceleratorApplication = (PageRoute [ "accelerator-application" ])
    , acceleratorProgram = (PageRoute [ "accelerator-program" ])
    , articles =
        { exitGatekeepers = (PageRoute [ "articles", "exit-gatekeepers" ])
        , index = (PageRoute [ "articles" ])
        , movingFasterWithTinySteps = (PageRoute [ "articles", "moving-faster-with-tiny-steps" ])
        , toTestOrNotToTest = (PageRoute [ "articles", "to-test-or-not-to-test" ])
        , all = [ (PageRoute [ "articles", "exit-gatekeepers" ]), (PageRoute [ "articles" ]), (PageRoute [ "articles", "moving-faster-with-tiny-steps" ]), (PageRoute [ "articles", "to-test-or-not-to-test" ]) ]
        }
    , contact = (PageRoute [ "contact" ])
    , coreSkillsSeminar = (PageRoute [ "core-skills-seminar" ])
    , customScalarChecklist = (PageRoute [ "custom-scalar-checklist" ])
    , elmGraphqlSeminar = (PageRoute [ "elm-graphql-seminar" ])
    , elmGraphqlWorkshop = (PageRoute [ "elm-graphql-workshop" ])
    , incrementalWeeklyUnsubscribe = (PageRoute [ "incremental-weekly-unsubscribe" ])
    , index = (PageRoute [  ])
    , introducingCustomScalarsCourse = (PageRoute [ "introducing-custom-scalars-course" ])
    , learn =
        { architecture = (PageRoute [ "learn", "architecture" ])
        , editorConfig = (PageRoute [ "learn", "editor-config" ])
        , gettingStarted = (PageRoute [ "learn", "getting-started" ])
        , index = (PageRoute [ "learn" ])
        , all = [ (PageRoute [ "learn", "architecture" ]), (PageRoute [ "learn", "editor-config" ]), (PageRoute [ "learn", "getting-started" ]), (PageRoute [ "learn" ]) ]
        }
    , scalarCodecsTutorial = (PageRoute [ "scalar-codecs-tutorial" ])
    , services = (PageRoute [ "services" ])
    , thankYou = (PageRoute [ "thank-you" ])
    , tips = (PageRoute [ "tips" ])
    , all = [ (PageRoute [ "accelerator-application" ]), (PageRoute [ "accelerator-program" ]), (PageRoute [ "contact" ]), (PageRoute [ "core-skills-seminar" ]), (PageRoute [ "custom-scalar-checklist" ]), (PageRoute [ "elm-graphql-seminar" ]), (PageRoute [ "elm-graphql-workshop" ]), (PageRoute [ "incremental-weekly-unsubscribe" ]), (PageRoute [  ]), (PageRoute [ "introducing-custom-scalars-course" ]), (PageRoute [ "scalar-codecs-tutorial" ]), (PageRoute [ "services" ]), (PageRoute [ "thank-you" ]), (PageRoute [ "tips" ]) ]
    }

urlParser : Url.Parser (PageRoute -> a) a
urlParser =
    Url.oneOf
        [ Url.map (PageRoute [ "accelerator-application" ]) (s "accelerator-application")
        , Url.map (PageRoute [ "accelerator-program" ]) (s "accelerator-program")
        , Url.map (PageRoute [ "articles", "exit-gatekeepers" ]) (s "articles" </> s "exit-gatekeepers")
        , Url.map (PageRoute [ "articles" ]) (s "articles" </> s "index")
        , Url.map (PageRoute [ "articles", "moving-faster-with-tiny-steps" ]) (s "articles" </> s "moving-faster-with-tiny-steps")
        , Url.map (PageRoute [ "articles", "to-test-or-not-to-test" ]) (s "articles" </> s "to-test-or-not-to-test")
        , Url.map (PageRoute [ "contact" ]) (s "contact")
        , Url.map (PageRoute [ "core-skills-seminar" ]) (s "core-skills-seminar")
        , Url.map (PageRoute [ "custom-scalar-checklist" ]) (s "custom-scalar-checklist")
        , Url.map (PageRoute [ "elm-graphql-seminar" ]) (s "elm-graphql-seminar")
        , Url.map (PageRoute [ "elm-graphql-workshop" ]) (s "elm-graphql-workshop")
        , Url.map (PageRoute [ "incremental-weekly-unsubscribe" ]) (s "incremental-weekly-unsubscribe")
        , Url.map (PageRoute [  ]) (s "index")
        , Url.map (PageRoute [ "introducing-custom-scalars-course" ]) (s "introducing-custom-scalars-course")
        , Url.map (PageRoute [ "learn", "architecture" ]) (s "learn" </> s "architecture")
        , Url.map (PageRoute [ "learn", "editor-config" ]) (s "learn" </> s "editor-config")
        , Url.map (PageRoute [ "learn", "getting-started" ]) (s "learn" </> s "getting-started")
        , Url.map (PageRoute [ "learn" ]) (s "learn" </> s "index")
        , Url.map (PageRoute [ "scalar-codecs-tutorial" ]) (s "scalar-codecs-tutorial")
        , Url.map (PageRoute [ "services" ]) (s "services")
        , Url.map (PageRoute [ "thank-you" ]) (s "thank-you")
        , Url.map (PageRoute [ "tips" ]) (s "tips")
        ] 

images =
    { architecture = (Image [ "architecture.jpg" ])
    , articleCover =
        { exit = (Image [ "article-cover", "exit.jpg" ])
        , mountains = (Image [ "article-cover", "mountains.jpg" ])
        , thinker = (Image [ "article-cover", "thinker.jpg" ])
        , all = [ (Image [ "article-cover", "exit.jpg" ]), (Image [ "article-cover", "mountains.jpg" ]), (Image [ "article-cover", "thinker.jpg" ]) ]
        }
    , buildrCropped = (Image [ "buildr-cropped.jpg" ])
    , contact = (Image [ "contact.jpg" ])
    , customScalarChecklist = (Image [ "custom-scalar-checklist.pdf" ])
    , dillon = (Image [ "dillon.jpg" ])
    , dillon2 = (Image [ "dillon2.jpg" ])
    , edGonzalez = (Image [ "ed-gonzalez.png" ])
    , elmGraphqlWorkshopHeader = (Image [ "elm-graphql-workshop-header.jpg" ])
    , graphqlWorkshop = (Image [ "graphql-workshop.png" ])
    , icon = (Image [ "icon.svg" ])
    , osloWorkshop1 = (Image [ "oslo-workshop1.jpg" ])
    , steps = (Image [ "steps.jpg" ])
    , workspace = (Image [ "workspace.jpg" ])
    , all = [ (Image [ "architecture.jpg" ]), (Image [ "buildr-cropped.jpg" ]), (Image [ "contact.jpg" ]), (Image [ "custom-scalar-checklist.pdf" ]), (Image [ "dillon.jpg" ]), (Image [ "dillon2.jpg" ]), (Image [ "ed-gonzalez.png" ]), (Image [ "elm-graphql-workshop-header.jpg" ]), (Image [ "graphql-workshop.png" ]), (Image [ "icon.svg" ]), (Image [ "oslo-workshop1.jpg" ]), (Image [ "steps.jpg" ]), (Image [ "workspace.jpg" ]) ]
    }

allImages : List Image
allImages =
    [(Image [ "architecture.jpg" ])
    , (Image [ "article-cover", "exit.jpg" ])
    , (Image [ "article-cover", "mountains.jpg" ])
    , (Image [ "article-cover", "thinker.jpg" ])
    , (Image [ "buildr-cropped.jpg" ])
    , (Image [ "contact.jpg" ])
    , (Image [ "custom-scalar-checklist.pdf" ])
    , (Image [ "dillon.jpg" ])
    , (Image [ "dillon2.jpg" ])
    , (Image [ "ed-gonzalez.png" ])
    , (Image [ "elm-graphql-workshop-header.jpg" ])
    , (Image [ "graphql-workshop.png" ])
    , (Image [ "icon.svg" ])
    , (Image [ "oslo-workshop1.jpg" ])
    , (Image [ "steps.jpg" ])
    , (Image [ "workspace.jpg" ])
    ]

routeToString : PageRoute -> String
routeToString (PageRoute route) =
    "/"
      ++ (route |> String.join "/")


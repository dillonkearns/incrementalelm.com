module Template.Tip exposing (..)

import Date exposing (Date)
import Element
import Element.Font as Font
import Head
import Head.Seo
import Pages
import Pages.ImagePath as ImagePath
import Pages.PagePath as PagePath exposing (PagePath)
import Palette
import Shared
import Site
import StructuredDataHelper
import Template exposing (StaticPayload)
import TemplateType
import Time
import Widget.Signup


type alias Model =
    ()


type alias Msg =
    Never


template : Template.Template TemplateType.TipMetadata ()
template =
    Template.noStaticData { head = head }
        |> Template.buildNoState { view = view }


view :
    List ( PagePath Pages.PathKey, TemplateType.TemplateType )
    -> Template.StaticPayload TemplateType.TipMetadata templateStaticData
    -> Shared.RenderedBody
    -> Shared.PageView Never
view allMetadata static viewForPage =
    { title = static.metadata.title
    , body =
        [ [ Element.paragraph
                [ Font.size 36
                , Font.center
                , Font.family [ Font.typeface "Raleway" ]
                , Font.bold
                ]
                [ Element.text static.metadata.title ]
          ]
        , [ Element.paragraph [ Element.padding 20 ] [ Palette.textQuote static.metadata.description ] ]
        , viewForPage
        , [ Widget.Signup.view "Get Weekly Tips" "906002494" [] ]
        ]
            |> List.concat
    }


head :
    StaticPayload TemplateType.TipMetadata ()
    -> List (Head.Tag Pages.PathKey)
head { metadata, path } =
    whenPublished metadata.publishedAt
        [ Head.structuredData
            (StructuredDataHelper.article
                { title = metadata.title
                , description = metadata.description
                , author = StructuredDataHelper.person { name = "Dillon Kearns" }
                , publisher = StructuredDataHelper.person { name = "Dillon Kearns" }
                , url = Site.canonicalUrl ++ "/" ++ PagePath.toString path
                , imageUrl = Site.canonicalUrl ++ "/" ++ ImagePath.toString Pages.images.articleCover.lofotenHike
                , datePublished = Date.toIsoString metadata.publishedAt
                , mainEntityOfPage =
                    StructuredDataHelper.softwareSourceCode
                        { codeRepositoryUrl = "https://github.com/dillonkearns/elm-pages"
                        , description = "A statically typed site generator for Elm."
                        , author = "Dillon Kearns"
                        , programmingLanguage = StructuredDataHelper.elmLang
                        }
                }
            )
        ]
        ++ (Head.Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = Site.name
                , image =
                    { url = Pages.images.articleCover.lofotenHike
                    , alt = metadata.description
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = metadata.description
                , title = metadata.title
                , locale = Nothing
                }
                |> Head.Seo.article
                    { tags = []
                    , section = Nothing
                    , publishedTime = Nothing
                    , modifiedTime = Nothing
                    , expirationTime = Nothing
                    }
           )


whenPublished : Date -> List b -> List b
whenPublished publishAt whenTrueValue =
    if onOrAfterPublishDate Pages.builtAt publishAt then
        whenTrueValue

    else
        []


onOrAfterPublishDate : Time.Posix -> Date -> Bool
onOrAfterPublishDate now publishDate =
    let
        zone =
            Time.utc
    in
    -- now >= publishDate
    Date.compare (Date.fromPosix zone now) publishDate /= LT

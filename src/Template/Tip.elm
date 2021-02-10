module Template.Tip exposing (..)

import Date exposing (Date)
import Element
import Element.Font as Font
import Head
import Head.Seo
import Html.Attributes as Attr
import Pages
import Pages.ImagePath as ImagePath
import Pages.PagePath as PagePath exposing (PagePath)
import Palette
import Shared
import Site
import StructuredDataHelper
import Style
import Template exposing (StaticPayload)
import TemplateType
import Time
import UnsplashImage
import Widget.Signup


type alias Model =
    ()


type alias Msg =
    Never


template : Template.Template_ TemplateType.TipMetadata ()
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
                , Font.alignLeft
                , Font.family [ Font.typeface "Open Sans" ]
                , Font.bold
                ]
                [ Element.text static.metadata.title ]
          ]
        , [ Element.row []
                [ Element.row
                    [ Element.htmlAttribute (Attr.class "avatar")
                    , Element.paddingEach
                        { bottom = 0
                        , left = 0
                        , right = 15
                        , top = 0
                        }
                    ]
                    [ Element.image
                        [ Element.width (Element.px 80)
                        , Element.height (Element.px 80)
                        ]
                        { src = "https://res.cloudinary.com/dillonkearns/image/upload/c_pad,w_180,q_auto,f_auto/v1602899672/elm-radio/dillon-profile_n2lqst.jpg"
                        , description = ""
                        }
                    ]
                , Element.paragraph
                    [ Font.size 20
                    , Font.alignLeft
                    , Font.family [ Font.typeface "Open Sans" ]
                    ]
                    [ Element.row [ Element.htmlAttribute (Attr.class "avatar") ]
                        [ Element.text "Dillon Kearns" |> Element.el [ Font.bold ]
                        ]
                    , " · "
                        ++ (static.metadata.publishedAt |> Date.format "MMMM d, y")
                        |> Element.text
                    ]
                ]
          ]
        , [ UnsplashImage.image [ Element.width Element.fill ] static.metadata.cover ]
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
                , imageUrl = metadata.cover |> UnsplashImage.rawUrl
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
                    { url = metadata.cover |> UnsplashImage.imagePath
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

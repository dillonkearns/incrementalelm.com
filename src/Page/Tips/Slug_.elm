module Page.Tips.Slug_ exposing (Data, Model, Msg, RouteParams, TipMetadata, page)

import DataSource exposing (DataSource)
import DataSource.Glob as Glob
import Date exposing (Date)
import Element exposing (Element)
import Element.Font as Font
import Head
import Head.Seo as Seo
import Html.Attributes as Attr
import MarkdownCodec
import MarkdownRenderer
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, StaticPayload)
import Pages
import Pages.PageUrl exposing (PageUrl)
import Palette
import Path
import Shared
import Site
import StructuredDataHelper
import Time
import UnsplashImage exposing (UnsplashImage)
import View exposing (View)
import Widget.Signup


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { slug : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    Glob.succeed RouteParams
        |> Glob.match (Glob.literal "content/tips/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


data : RouteParams -> DataSource Data
data routeParams =
    MarkdownCodec.withFrontmatter Data
        decoder
        MarkdownRenderer.renderer
        ("content/tips/" ++ routeParams.slug ++ ".md")


type alias Data =
    { metadata : TipMetadata
    , body : List (Element Msg)
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.metadata.title
    , body =
        View.ElmUi
            ([ [ Element.paragraph
                    [ Font.size 36
                    , Font.alignLeft
                    , Font.family [ Font.typeface "Open Sans" ]
                    , Font.bold
                    ]
                    [ Element.text static.data.metadata.title ]
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
                            ++ (static.data.metadata.publishedAt |> Date.format "MMMM d, y")
                            |> Element.text
                        ]
                    ]
               ]

             --, [ UnsplashImage.image [ Element.width Element.fill ] static.data.metadata.cover ]
             , [ Element.paragraph [ Element.padding 20 ] [ Palette.textQuote static.data.metadata.description ] ]
             , static.data.body
             , [ Widget.Signup.view "Get Weekly Tips" "906002494" [] ]
             ]
                |> List.concat
            )
    }


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    whenPublished static.data.metadata.publishedAt
        [ Head.structuredData
            (StructuredDataHelper.article
                { title = static.data.metadata.title
                , description = static.data.metadata.description
                , author = StructuredDataHelper.person { name = "Dillon Kearns" }
                , publisher = StructuredDataHelper.person { name = "Dillon Kearns" }
                , url =
                    Path.join ([ Site.canonicalUrl ] ++ [ static.routeParams.slug ])
                        |> Path.toAbsolute
                , imageUrl = static.data.metadata.cover |> UnsplashImage.rawUrl
                , datePublished = Date.toIsoString static.data.metadata.publishedAt
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
        ++ (Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = "Incremental Elm"
                , image =
                    { url = static.data.metadata.cover |> UnsplashImage.imagePath
                    , alt = static.data.metadata.description
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = static.data.metadata.description
                , title = static.data.metadata.title
                , locale = Nothing
                }
                |> Seo.article
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


type alias TipMetadata =
    { title : String
    , description : String
    , publishedAt : Date
    , cover : UnsplashImage
    }


decoder : Decoder TipMetadata
decoder =
    Decode.map4 TipMetadata
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "publishAt"
            (Decode.string
                |> Decode.andThen
                    (\isoString ->
                        case Date.fromIsoString isoString of
                            Ok date ->
                                Decode.succeed date

                            Err error ->
                                Decode.fail error
                    )
            )
        )
        (Decode.optionalField "cover" UnsplashImage.decoder
            |> Decode.map (Maybe.withDefault defaultImage)
        )


defaultImage : UnsplashImage
defaultImage =
    UnsplashImage.fromId "1587382668076-5101b7cd8eae"

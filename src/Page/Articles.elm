module Page.Articles exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Element exposing (Element)
import Element.Border
import Element.Font
import Head
import Head.Seo as Seo
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path exposing (Path)
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.singleRoute
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    allArticleMetadata


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    List ( Path, ArticleMetadata )


type alias Article =
    { slug : String
    , filePath : String
    }


articles : DataSource (List Article)
articles =
    Glob.succeed Article
        |> Glob.match (Glob.literal "content/articles/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.capture Glob.fullFilePath
        |> Glob.toDataSource


allArticleMetadata : DataSource (List ( Path, ArticleMetadata ))
allArticleMetadata =
    articles
        |> DataSource.map
            (List.map
                (\article ->
                    DataSource.map2 Tuple.pair
                        (DataSource.succeed
                            (Path.fromString "")
                        )
                        (DataSource.File.request
                            article.filePath
                            (DataSource.File.frontmatter articleDecoder)
                        )
                )
            )
        |> DataSource.resolve


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Articles"
    , body =
        [ --Element.column []
          --    (static.data
          --        |> List.map (\article -> Element.text article.title)
          --    )
          viewMain static.data
        ]
    }


viewMain :
    List ( Path, ArticleMetadata )
    -> Element msg
viewMain posts =
    Element.column [ Element.spacing 20 ]
        (posts
            |> List.map postSummary
        )


postSummary :
    ( Path, ArticleMetadata )
    -> Element msg
postSummary ( postPath, post ) =
    articleIndex post
        |> linkToPost postPath


linkToPost : Path -> Element msg -> Element msg
linkToPost postPath content =
    Element.link [ Element.width Element.fill ]
        { url = Path.toAbsolute postPath, label = content }


title : String -> Element msg
title text =
    [ Element.text text ]
        |> Element.paragraph
            [ Element.Font.size 36
            , Element.Font.center
            , Element.Font.family [ Element.Font.typeface "Raleway" ]
            , Element.Font.semiBold
            , Element.padding 16
            ]


articleIndex : ArticleMetadata -> Element msg
articleIndex metadata =
    Element.el
        [ Element.centerX
        , Element.width (Element.maximum 800 Element.fill)
        , Element.padding 40
        , Element.spacing 10
        , Element.Border.width 1
        , Element.Border.color (Element.rgba255 0 0 0 0.1)
        , Element.mouseOver
            [ Element.Border.color (Element.rgba255 0 0 0 1)
            ]
        ]
        (postPreview metadata)


readMoreLink : Element msg
readMoreLink =
    Element.text "Continue reading >>"
        |> Element.el
            [ Element.centerX
            , Element.Font.size 18
            , Element.alpha 0.6
            , Element.mouseOver [ Element.alpha 1 ]
            , Element.Font.underline
            , Element.Font.center
            ]


postPreview : ArticleMetadata -> Element msg
postPreview post =
    Element.textColumn
        [ Element.centerX
        , Element.width Element.fill
        , Element.spacing 30
        , Element.Font.size 18
        ]
        [ title post.title
        , image post
        , post.description
            |> Element.text
            |> List.singleton
            |> Element.paragraph
                [ Element.Font.size 22
                , Element.Font.center
                , Element.Font.family [ Element.Font.typeface "Raleway" ]
                ]
        , readMoreLink
        ]


image : ArticleMetadata -> Element msg
image article =
    Element.image
        [ Element.width (Element.fill |> Element.maximum 600)
        , Element.centerX
        ]
        { src = article.coverImage
        , description = article.title ++ " cover image"
        }
        |> Element.el [ Element.centerX ]


type alias ArticleMetadata =
    { title : String
    , description : String
    , coverImage : String
    }


articleDecoder : Decoder ArticleMetadata
articleDecoder =
    Decode.map3 ArticleMetadata
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "src" Decode.string |> Decode.map (\path -> Path.join [ "images/", path ] |> Path.toRelative))

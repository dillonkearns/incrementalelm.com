module Page.Index exposing (Data, Model, Msg, RouteParams, page)

import DataSource exposing (DataSource)
import DataSource.Http
import Fauna.Object.Views
import Fauna.Query
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (Html, div)
import Html.Styled.Attributes exposing (css)
import MarkdownCodec
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Request.Fauna
import Shared
import TailwindMarkdownRenderer2
import UnsplashImage
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


mostViewedSelection : SelectionSet (List String) RootQuery
mostViewedSelection =
    Fauna.Query.mostViewedPaths Fauna.Object.Views.path


mostViewed : DataSource (List String)
mostViewed =
    Request.Fauna.dataSource mostViewedSelection


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    DataSource.map2 Data
        (MarkdownCodec.withoutFrontmatter TailwindMarkdownRenderer2.renderer "content/index.md"
            |> DataSource.resolve
        )
        mostViewed


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = UnsplashImage.default |> UnsplashImage.rawUrl |> Pages.Url.external
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Tips and tools for Elm programmers."
        , locale = Nothing
        , title = "Incremental Elm"
        }
        |> Seo.website


type alias Data =
    { body : List (Html Msg)
    , mostViewedPaths : List String
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Incremental Elm"
    , body =
        View.Tailwind
            [ div
                [ css
                    []
                ]
                static.data.body
            ]
    }

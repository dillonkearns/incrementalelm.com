module Page.Index exposing (Data, Model, Msg, RouteParams, page)

import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Html, div)
import Html.Styled.Attributes exposing (css)
import MarkdownCodec
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import TailwindMarkdownRenderer2
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    DataSource.map Data
        (MarkdownCodec.withoutFrontmatter TailwindMarkdownRenderer2.renderer "content/index.md"
            |> DataSource.resolve
        )


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
        , title = "Incremental Elm"
        }
        |> Seo.website


type alias Data =
    { body : List (Html Msg)
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

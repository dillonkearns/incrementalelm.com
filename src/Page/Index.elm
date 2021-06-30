module Page.Index exposing (Data, Model, Msg, RouteParams, page)

import Css
import DataSource exposing (DataSource)
import Element exposing (Element)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Html, div)
import Html.Styled.Attributes exposing (css)
import MarkdownCodec
import MarkdownRenderer
import OptimizedDecoder as Decode
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Tailwind.Utilities as Tw
import TailwindMarkdownRenderer
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
    MarkdownCodec.withFrontmatter Data
        (Decode.field "title" Decode.string)
        TailwindMarkdownRenderer.renderer
        "content/index.md"


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
    { metadata : String
    , body : List (Html Msg)
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.metadata
    , body =
        View.Tailwind
            [ div
                [ css
                    []
                ]
                static.data.body
            ]
    }

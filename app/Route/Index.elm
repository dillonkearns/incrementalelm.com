module Route.Index exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (div)
import Html.Styled.Attributes exposing (css)
import Dict exposing (Dict)
import MarkdownCodec
import PagesMsg exposing (PagesMsg)
import Pages.Url
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import Shiki
import TailwindMarkdownViewRenderer
import UnsplashImage
import View exposing (View, freeze)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    MarkdownCodec.bodyAndHighlights "content/index.md"
        |> BackendTask.map (\bh -> Data bh.body bh.highlights)


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
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
    { body : String
    , highlights : Dict String Shiki.Highlighted
    }


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app sharedModel =
    { title = "Incremental Elm"
    , body =
        View.Tailwind
            [ (MarkdownCodec.renderMarkdown (TailwindMarkdownViewRenderer.renderer app.data.highlights) app.data.body
                |> Result.withDefault [ Html.text "Error rendering markdown" ]
                |> div []
                |> Html.toUnstyled
              )
                |> freeze
                |> Html.fromUnstyled
            ]
    }

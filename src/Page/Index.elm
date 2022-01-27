module Page.Index exposing (Data, Model, Msg, RouteParams, page)

import Css
import DataSource exposing (DataSource)
import Fauna.Object.Views
import Fauna.Query
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (Html, div, text)
import Html.Styled.Attributes exposing (css)
import Link
import Markdown.Block exposing (Block)
import MarkdownCodec
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Request.Fauna
import Route exposing (Route)
import Shared
import Tailwind.Utilities as Tw
import TailwindMarkdownRenderer2
import UnsplashImage
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


mostViewedSelection : SelectionSet (List ( String, Int )) RootQuery
mostViewedSelection =
    Fauna.Query.mostViewedPaths
        (SelectionSet.map2 Tuple.pair
            Fauna.Object.Views.path
            Fauna.Object.Views.hits
        )
        |> SelectionSet.map
            (\items ->
                items
                    |> List.sortBy Tuple.second
                    |> List.reverse
                    |> List.take 5
            )


mostViewed : DataSource (List ( String, Int ))
mostViewed =
    Request.Fauna.dataSource mostViewedSelection


type alias Note =
    { title : String
    , description : String
    , route : Route
    }


mostViewedEnhanced : DataSource (List Note)
mostViewedEnhanced =
    mostViewed
        |> DataSource.map
            (\items ->
                items
                    |> List.map
                        (\( path, hits ) ->
                            DataSource.map (\{ title, description } route -> { title = title, description = description, route = route })
                                (("content/" ++ String.dropLeft 1 path ++ ".md")
                                    |> MarkdownCodec.titleAndDescription
                                )
                                |> DataSource.andMap
                                    (Route.urlToRoute { path = path }
                                        |> Result.fromMaybe "Could not parse path to route"
                                        |> DataSource.fromResult
                                    )
                        )
            )
        |> DataSource.resolve


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
         --|> DataSource.resolve
        )
        mostViewedEnhanced


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
    { body : List Block
    , mostViewedPaths : List Note
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
                --static.data.body
                []
            , Html.h2
                [ css
                    [ Tw.text_4xl
                    , Tw.text_center
                    , Tw.pt_8
                    , Tw.pb_8
                    , Tw.text_foregroundStrong
                    , Tw.font_bold
                    ]
                ]
                [ text "Popular Posts" ]
            , mostViewedSection static
            ]
    }


mostViewedSection : StaticPayload Data RouteParams -> Html msg
mostViewedSection static =
    Html.div
        []
        [ Html.ul
            [ css
                [ Tw.grid
                , Tw.space_y_4
                ]
            ]
            (List.map
                noteCard
                static.data.mostViewedPaths
            )
        ]


noteCard : Note -> Html msg
noteCard note =
    Html.li
        [ css
            [ Tw.border_2
            , Tw.rounded_lg
            , Tw.border_solid
            , Tw.border_background
            , Css.hover
                [ Tw.border_foreground
                ]
            ]
        ]
        [ note.route
            |> Link.htmlLink2 []
                [ Html.div
                    [ css
                        [ Tw.p_8
                        , Tw.cursor_pointer
                        ]
                    ]
                    [ Html.h2
                        [ css
                            [ Tw.font_bold
                            , Tw.text_lg
                            , Tw.text_foregroundStrong
                            , Tw.pb_2
                            , [ Css.qt "Raleway" ] |> Css.fontFamilies
                            ]
                        ]
                        [ text <|
                            note.title
                        ]
                    , div
                        [ css
                            [ Tw.text_sm
                            , Tw.text_foregroundLight
                            ]
                        ]
                        [ text note.description
                        ]
                    ]
                ]
        ]

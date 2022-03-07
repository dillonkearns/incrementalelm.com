module Route.Notes exposing (Data, Model, Msg, Note, RouteParams, route)

import Browser.Navigation
import Css
import DataSource exposing (DataSource)
import DataSource.Glob as Glob
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import Html.Styled.Events
import Link
import MarkdownCodec
import Page exposing (PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Route exposing (Route)
import Shared
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import View exposing (View)


type alias Model =
    String


type Msg
    = OnSearchInput String


type alias RouteParams =
    {}


route : PageWithState RouteParams Data Model Msg
route =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildWithLocalState
            { view = view
            , update = update
            , subscriptions = \_ _ _ _ _ -> Sub.none
            , init =
                \_ _ _ ->
                    ( "", Cmd.none )
            }


update :
    PageUrl
    -> Maybe Browser.Navigation.Key
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> Msg
    -> Model
    -> ( Model, Cmd Msg )
update _ _ _ _ msg model =
    case msg of
        OnSearchInput newInput ->
            ( newInput, Cmd.none )


data : DataSource Data
data =
    DataSource.map Data
        nonEmptyNotes


type alias Data =
    { notes : List Note
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel model static =
    { title = "Incremental Elm Wiki"
    , body =
        View.Tailwind
            [ div
                [ css
                    [ Tw.font_bold
                    , Tw.text_xl
                    , Tw.text_center
                    , Css.fontFamilies [ "Raleway" ]
                    ]
                ]
                [ text "Incremental Elm Notes" ]

            --, input
            --    [ Attr.type_ "text"
            --    , Attr.value model
            --    , Html.Styled.Events.onInput OnSearchInput
            --    ]
            --    []
            , searchInput model
            , -- Html.Styled.Lazy.lazy2
              notesList model static.data.notes
            ]
    }


notesList searchQuery notes =
    ul
        [ css
            [ Tw.list_disc
            , Tw.mb_5
            , Tw.mt_5
            ]
        ]
        (notes
            |> List.filterMap
                (\note ->
                    if noteMatches searchQuery note then
                        note.route
                            |> Link.htmlLink
                                [ css
                                    [ Css.hover
                                        [ Css.color (Css.rgb 226 0 124)
                                        ]
                                    ]
                                ]
                                (text note.title)
                            |> List.singleton
                            |> li
                                [ css
                                    [ Tw.ml_7
                                    , Tw.mb_2
                                    , Tw.mt_2
                                    ]
                                ]
                            |> Just

                    else
                        Nothing
                )
        )


noteMatches : String -> Note -> Bool
noteMatches query note =
    note.title |> String.toLower |> String.contains (query |> String.toLower)


type alias Note =
    { route : Route
    , slug : String
    , title : String
    }


nonEmptyNotes : DataSource (List Note)
nonEmptyNotes =
    Glob.succeed
        (\filePath topic ->
            MarkdownCodec.isPlaceholder filePath
                |> DataSource.map
                    (Maybe.map
                        (\() ->
                            MarkdownCodec.noteTitle filePath
                                |> DataSource.map
                                    (\title ->
                                        { route = Route.Page_ { page = topic }
                                        , slug = topic
                                        , title = title
                                        }
                                    )
                        )
                    )
        )
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource
        |> DataSource.resolve
        |> DataSource.map (List.filterMap identity)
        |> DataSource.resolve
        |> DataSource.map (List.filter (\{ slug } -> slug /= "index"))


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = "Incremental Elm"
        , image =
            { url = Pages.Url.external ""
            , alt = "Incremental Elm Wiki"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Incremental Elm Wiki"
        , title = "Incremental Elm Wiki"
        , locale = Nothing
        }
        |> Seo.article
            { tags = []
            , section = Nothing
            , publishedTime = Nothing
            , modifiedTime = Nothing
            , expirationTime = Nothing
            }


searchInput : String -> Html Msg
searchInput searchQuery =
    div
        []
        [ label
            [ Attr.for "filter"
            , css
                [ Tw.block
                , Tw.text_sm
                , Tw.font_medium
                ]
            ]
            [ text "Filter" ]
        , div
            [ css
                [ Tw.mt_1
                ]
            ]
            [ input
                [ Attr.type_ "text"
                , Attr.name "filter"
                , Attr.id "search"
                , Attr.value searchQuery
                , Html.Styled.Events.onInput OnSearchInput
                , css
                    [ Tw.shadow_sm
                    , Tw.block
                    , Tw.w_full

                    --, Tw.form_input
                    , Tw.rounded_md
                    , Tw.border_gray_700
                    , Tw.rounded
                    , Bp.sm
                        [ Tw.text_sm
                        ]
                    ]
                , Attr.placeholder "Your Filter Query"
                ]
                []
            ]
        ]

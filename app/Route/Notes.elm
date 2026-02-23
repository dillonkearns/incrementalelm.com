module Route.Notes exposing (ActionData, Data, Model, Msg, Note, RouteParams, route)

import BackendTask exposing (BackendTask)
import BackendTask.Glob as Glob
import Effect exposing (Effect)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events
import Link
import MarkdownCodec
import PagesMsg exposing (PagesMsg)
import Pages.Url
import Route exposing (Route)
import RouteBuilder exposing (App, StatefulRoute)
import Shared
import Tailwind as Tw exposing (classes)
import Tailwind.Breakpoints exposing (sm)
import Tailwind.Theme exposing (s1, s2, s5, s7)
import UrlPath exposing (UrlPath)
import View exposing (View)


type alias Model =
    String


type Msg
    = OnSearchInput String


type alias RouteParams =
    {}


type alias ActionData =
    {}


route : StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildWithLocalState
            { view = view
            , update = update
            , subscriptions = \_ _ _ _ -> Sub.none
            , init =
                \_ _ ->
                    ( "", Effect.none )
            }


update :
    App Data ActionData RouteParams
    -> Shared.Model
    -> Msg
    -> Model
    -> ( Model, Effect Msg )
update _ _ msg model =
    case msg of
        OnSearchInput newInput ->
            ( newInput, Effect.none )


data : BackendTask FatalError Data
data =
    BackendTask.map Data
        nonEmptyNotes


type alias Data =
    { notes : List Note
    }


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View (PagesMsg Msg)
view app sharedModel model =
    { title = "Incremental Elm Wiki"
    , body =
        View.Tailwind
            (List.map (Html.map PagesMsg.fromMsg)
                [ div
                    [ classes
                        [ Tw.raw "font-bold"
                        , Tw.raw "text-xl"
                        , Tw.text_center
                        , Tw.raw "font-raleway"
                        ]
                    ]
                    [ text "Incremental Elm Notes" ]
                , searchInput model
                , notesList model app.data.notes
                ]
            )
    }


notesList : String -> List Note -> Html Msg
notesList searchQuery noteList =
    ul
        [ classes
            [ Tw.raw "list-disc"
            , Tw.mb s5
            , Tw.mt s5
            ]
        ]
        (noteList
            |> List.filterMap
                (\note ->
                    if noteMatches searchQuery note then
                        note.route
                            |> Link.htmlLink
                                [ classes
                                    [ Tw.raw "hover:text-pink-link"
                                    ]
                                ]
                                (text note.title)
                            |> List.singleton
                            |> li
                                [ classes
                                    [ Tw.ml s7
                                    , Tw.mb s2
                                    , Tw.mt s2
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


nonEmptyNotes : BackendTask FatalError (List Note)
nonEmptyNotes =
    Glob.succeed
        (\filePath topic ->
            MarkdownCodec.isPlaceholder filePath
                |> BackendTask.andThen
                    (\maybeNotPlaceholder ->
                        case maybeNotPlaceholder of
                            Nothing ->
                                BackendTask.succeed Nothing

                            Just () ->
                                MarkdownCodec.noteTitle filePath
                                    |> BackendTask.map
                                        (\title ->
                                            Just
                                                { route = Route.Page_ { page = topic }
                                                , slug = topic
                                                , title = title
                                                }
                                        )
                    )
        )
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "garden/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask
        |> BackendTask.andThen
            (\items ->
                items
                    |> BackendTask.combine
            )
        |> BackendTask.map (List.filterMap identity)
        |> BackendTask.map (List.filter (\{ slug } -> slug /= "index"))


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
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
            , classes
                [ Tw.block
                , Tw.raw "text-sm"
                , Tw.raw "font-medium"
                ]
            ]
            [ text "Filter" ]
        , div
            [ classes
                [ Tw.mt s1
                ]
            ]
            [ input
                [ Attr.type_ "text"
                , Attr.name "filter"
                , Attr.id "search"
                , Attr.value searchQuery
                , Html.Events.onInput OnSearchInput
                , classes
                    [ Tw.raw "shadow-sm"
                    , Tw.block
                    , Tw.w_full
                    , Tw.raw "rounded-md"
                    , Tw.raw "border-gray-700"
                    , Tw.rounded
                    , sm
                        [ Tw.raw "text-sm"
                        ]
                    ]
                , Attr.placeholder "Your Filter Query"
                ]
                []
            ]
        ]

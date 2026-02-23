module Route.Live exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import PagesMsg exposing (PagesMsg)
import Pages.Url
import Request
import Request.Events exposing (LiveStream)
import RouteBuilder exposing (App, StatelessRoute)
import Scalar exposing (DateTime, Id)
import Shared
import Time
import TwitchButton
import View exposing (View)


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
    Request.staticGraphqlRequest Request.Events.selection


type alias Data =
    List LiveStream


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app sharedModel =
    let
        now : Maybe Time.Posix
        now =
            sharedModel.now

        isOnAir : TwitchButton.IsOnAir
        isOnAir =
            sharedModel.isOnAir
    in
    { title = "Incremental Elm Live Streams"
    , body =
        View.Tailwind
            [ eventsView now isOnAir app.data
            ]
    }


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external ""
            , alt = "Incremental Elm live streams"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Incremental Elm live streams"
        , title = "Incremental Elm live streams"
        , locale = Nothing
        }
        |> Seo.website


eventsView : Maybe Time.Posix -> TwitchButton.IsOnAir -> List LiveStream -> Html msg
eventsView maybeNow isOnAir events =
    let
        upcoming : List LiveStream
        upcoming =
            events
                |> List.filter
                    (\event ->
                        case maybeNow of
                            Just now ->
                                Time.posixToMillis event.startsAt > Time.posixToMillis now

                            Nothing ->
                                True
                    )
                |> List.sortBy
                    (\event ->
                        Time.posixToMillis event.startsAt
                    )

        recordings :
            List
                { title : String
                , startsAt : DateTime
                , description : String
                , guest : List Request.Events.Guest
                , project : Maybe Request.Events.Project
                , youtubeId : Maybe String
                , id : Id
                , createdAt : DateTime
                }
        recordings =
            events
                |> List.filter
                    (\event ->
                        case maybeNow of
                            Just now ->
                                Time.posixToMillis event.startsAt <= Time.posixToMillis now

                            Nothing ->
                                False
                    )
                |> List.sortBy
                    (\event ->
                        -(Time.posixToMillis event.startsAt)
                    )
    in
    Html.div []
        (TwitchButton.viewIfOnAir isOnAir (Html.text "")
            :: ((upcoming |> List.map Request.Events.view)
                    ++ (recordings |> List.map Request.Events.recordingView2)
               )
        )

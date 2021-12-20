module Page.Live exposing (Data, Model, Msg, RouteParams, page)

--import TemplateType exposing (TemplateType)

import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (Html)
import Page exposing (Page, StaticPayload)
import Pages
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Request
import Request.Events exposing (LiveStream)
import Scalar exposing (DateTime, Id)
import Shared
import Time
import TwitchButton
import View exposing (View)


type alias Model =
    {}


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
    Request.staticGraphqlRequest Request.Events.selection



--head :
--    StaticPayload Data RouteParams
--    -> List Head.Tag
--head static =
--    Seo.summary
--        { canonicalUrlOverride = Nothing
--        , siteName = "elm-pages"
--        , image =
--            { url = Pages.Url.external "TODO"
--            , alt = "elm-pages logo"
--            , dimensions = Nothing
--            , mimeType = Nothing
--            }
--        , description = "TODO"
--        , locale = Nothing
--        , title = "TODO title" -- metadata.title -- TODO
--        }
--        |> Seo.website


type alias Data =
    List LiveStream


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    let
        now : Maybe Time.Posix
        now =
            -- TODO
            Just Pages.builtAt

        isOnAir : TwitchButton.IsOnAir
        isOnAir =
            -- TODO
            TwitchButton.notOnAir
    in
    { title = "Incremental Elm Live Streams"
    , body =
        View.Tailwind
            [ eventsView now isOnAir static.data
            ]
    }


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "" -- metadata.image |> Maybe.withDefault Pages.images.icon
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

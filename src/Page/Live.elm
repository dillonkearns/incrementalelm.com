module Page.Live exposing (Data, Model, Msg, page)

--import TemplateType exposing (TemplateType)

import DataSource exposing (DataSource)
import Element exposing (Element)
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Request
import Request.Events exposing (LiveStream)
import Shared
import Time
import TwitchButton
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



--view :
--    Maybe PageUrl
--    -> Shared.Model
--    -> StaticPayload Data RouteParams
--    -> View Msg
--view maybeUrl sharedModel static =
--    { title = "elm-pages live streams"
--    , body =
--        []
--    }
--staticData :
--    List ( PagePath Pages.PathKey, TemplateType )
--    -> StaticHttp.Request StaticData
--staticData siteMetadata =
--    Request.staticGraphqlRequest Request.Events.selection
--view :
--    List ( Pages.PagePath.PagePath Pages.PathKey, TemplateType.TemplateType )
--    -> Template.StaticPayload TemplateType.LiveIndexMetadata StaticData
--    -> Shared.RenderedBody
--    -> Shared.PageView Never
--view allMetadata static viewForPage =


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    let
        now =
            -- TODO
            Just Pages.builtAt

        isOnAir =
            -- TODO
            TwitchButton.notOnAir
    in
    { title = "Incremental Elm Live Streams" --static.metadata.title
    , body =
        --viewForPage
        [ eventsView now isOnAir static.data ]
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


eventsView : Maybe Time.Posix -> TwitchButton.IsOnAir -> List LiveStream -> Element msg
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
    TwitchButton.viewIfOnAir isOnAir Element.none
        :: ((upcoming |> List.map Request.Events.view)
                ++ (recordings |> List.map Request.Events.recordingView)
           )
        |> Element.column [ Element.spacing 30, Element.centerX ]

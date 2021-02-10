module Template.LiveIndex exposing (..)

import Element exposing (Element)
import Head
import Head.Seo
import Pages
import Pages.PagePath exposing (PagePath)
import Pages.StaticHttp as StaticHttp
import Request
import Request.Events exposing (LiveStream)
import Shared
import Site
import Template exposing (StaticPayload)
import TemplateType exposing (TemplateType)
import Time
import TwitchButton


type alias Model =
    ()


type alias Msg =
    Never


type alias StaticData =
    List LiveStream


template : Template.Template TemplateType.LiveIndexMetadata StaticData
template =
    Template.withStaticData { staticData = staticData, head = head }
        |> Template.buildNoState { view = view }


staticData :
    List ( PagePath Pages.PathKey, TemplateType )
    -> StaticHttp.Request StaticData
staticData siteMetadata =
    Request.staticGraphqlRequest Request.Events.selection


view :
    List ( Pages.PagePath.PagePath Pages.PathKey, TemplateType.TemplateType )
    -> Template.StaticPayload TemplateType.LiveIndexMetadata StaticData
    -> Shared.RenderedBody
    -> Shared.PageView Never
view allMetadata static viewForPage =
    let
        now =
            -- TODO
            Just Pages.builtAt

        isOnAir =
            -- TODO
            TwitchButton.notOnAir
    in
    { title = static.metadata.title
    , body =
        viewForPage
            ++ [ eventsView now isOnAir static.static ]
    }


head :
    StaticPayload TemplateType.LiveIndexMetadata StaticData
    -> List (Head.Tag Pages.PathKey)
head { metadata } =
    Head.Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = Site.name
        , image =
            { url = metadata.image |> Maybe.withDefault Pages.images.icon
            , alt = metadata.title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = metadata.description |> Maybe.withDefault metadata.title
        , title = metadata.title
        , locale = Nothing
        }
        |> Head.Seo.website


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

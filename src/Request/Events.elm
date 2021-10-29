module Request.Events exposing (Guest, LiveStream, NamedZone, Project, guestSelection, imageSelection, liveStreamSelection, projectSelection, recordingView2, selection, view)

import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr exposing (css)
import Icon
import Json.Encode as Encode
import Request.GoogleCalendar as GoogleCalendar
import SanityApi.Object
import SanityApi.Object.Guest
import SanityApi.Object.Image
import SanityApi.Object.LiveStream
import SanityApi.Object.Project
import SanityApi.Object.SanityImageAsset
import SanityApi.Query as Query
import Scalar exposing (DateTime)
import Tailwind.Utilities as Tw
import Time
import Youtube


type alias NamedZone =
    { name : String
    , zone : Time.Zone
    }


selection : SelectionSet (List LiveStream) RootQuery
selection =
    Query.allLiveStream identity liveStreamSelection


type alias LiveStream =
    { title : String
    , startsAt : DateTime
    , description : String
    , guest : List Guest
    , project : Maybe Project
    , youtubeId : Maybe String
    , id : Scalar.Id
    , createdAt : DateTime
    }


type alias Guest =
    { name : String
    , twitter : Maybe String
    , github : Maybe String
    , avatarUrl : Maybe String
    }


guestSelection : SelectionSet Guest SanityApi.Object.Guest
guestSelection =
    SelectionSet.map4 Guest
        (SanityApi.Object.Guest.name |> SelectionSet.nonNullOrFail)
        SanityApi.Object.Guest.twitter
        SanityApi.Object.Guest.github
        (SanityApi.Object.Guest.avatarUrl imageSelection)


imageSelection =
    SanityApi.Object.Image.asset SanityApi.Object.SanityImageAsset.url
        |> SelectionSet.nonNullOrFail
        |> SelectionSet.nonNullOrFail


type alias Project =
    { name : String }


projectSelection : SelectionSet Project SanityApi.Object.Project
projectSelection =
    SelectionSet.map Project
        (SanityApi.Object.Project.name |> SelectionSet.nonNullOrFail)


liveStreamSelection : SelectionSet LiveStream SanityApi.Object.LiveStream
liveStreamSelection =
    SelectionSet.map8 LiveStream
        (SanityApi.Object.LiveStream.title
            |> SelectionSet.nonNullOrFail
        )
        (SanityApi.Object.LiveStream.date
            |> SelectionSet.nonNullOrFail
        )
        (SanityApi.Object.LiveStream.description
            |> SelectionSet.withDefault ""
        )
        (SanityApi.Object.LiveStream.guest guestSelection
            |> SelectionSet.withDefault []
            |> SelectionSet.nonNullElementsOrFail
        )
        (SanityApi.Object.LiveStream.project projectSelection)
        SanityApi.Object.LiveStream.youtubeID
        (SanityApi.Object.LiveStream.id_ |> SelectionSet.nonNullOrFail)
        (SanityApi.Object.LiveStream.createdAt_ |> SelectionSet.nonNullOrFail)


view : LiveStream -> Html msg
view event =
    Html.div
        []
        [ Html.p
            [ css
                [ Tw.shadow_lg
                , Tw.p_8
                , Tw.max_w_md
                , Tw.space_y_5
                ]
            ]
            [ Html.text event.title
            ]
        , guestsView event.guest
        , Html.p
            [ css [ Tw.text_xs ]
            ]
            [ Html.text event.description ]
        , Html.div []
            [ Html.node "intl-time"
                [ Attr.property "editorValue" (event.startsAt |> Time.posixToMillis |> Encode.int)
                , css
                    [ Tw.text_sm
                    , Tw.font_bold
                    ]
                ]
                []
            ]
        , Html.a
            [ Attr.href (GoogleCalendar.googleAddToCalendarLink event)
            , css
                [ Tw.rounded_xl
                , Tw.text_background
                , Tw.bg_foreground
                ]
            ]
            [ Html.text "Add to Google Calendar"
            ]

        -- , TwitchButton.view
        ]


recordingView2 : LiveStream -> Html msg
recordingView2 event =
    case event.youtubeId of
        Nothing ->
            Html.text ""

        Just youtubeId ->
            Html.div
                [ css
                    [ Tw.shadow_lg
                    , Tw.p_8
                    , Tw.max_w_md
                    , Tw.space_y_5
                    ]
                ]
                [ Youtube.view youtubeId |> Html.fromUnstyled
                , Html.p
                    [ css
                        [ Tw.font_bold
                        , Tw.text_xl
                        ]
                    ]
                    [ Html.text event.title ]
                , guestsView event.guest
                , Html.p
                    [ css [ Tw.text_xs ]
                    ]
                    [ Html.text event.description ]
                , Html.div []
                    [ Html.node "intl-time"
                        [ Attr.property "editorValue" (event.startsAt |> Time.posixToMillis |> Encode.int)
                        , css
                            [ Tw.text_sm
                            , Tw.font_bold
                            ]
                        ]
                        []
                    ]
                ]


guestsView : List Guest -> Html msg
guestsView guests =
    Html.div
        [ css [ Tw.text_sm ]
        ]
        (List.map guestView guests)


guestView : { a | name : String, twitter : Maybe String, github : Maybe String } -> Html msg
guestView guest =
    Html.div
        [ css [ Tw.space_x_2, Tw.flex ]
        ]
        [ Html.div []
            [ [ Html.text "Guest: " ]
                |> Html.span
                    [ css [] ]
            , Html.text guest.name
            ]
        , socialBadges guest
        ]


socialBadges : { a | twitter : Maybe String, github : Maybe String } -> Html msg
socialBadges guest =
    Html.div
        [ css
            [ Tw.flex
            , Tw.space_x_2
            ]
        ]
        ([ guest.twitter
            |> Maybe.map
                (\twitter ->
                    Html.a
                        [ Attr.href ("https://twitter.com/" ++ twitter) ]
                        [ Icon.twitter ]
                )
         , guest.github
            |> Maybe.map
                (\github ->
                    Html.a
                        [ Attr.href ("https://github.com/" ++ github) ]
                        [ Icon.github ]
                )
         ]
            |> List.filterMap identity
        )

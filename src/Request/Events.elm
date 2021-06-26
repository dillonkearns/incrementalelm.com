module Request.Events exposing (Guest, LiveStream, NamedZone, Project, guestSelection, guestView, guestsView, imageSelection, liveStreamSelection, projectSelection, projectView, recordingView, selection, socialBadges, view)

import Element exposing (Element)
import Element.Border as Border
import Element.Font as Font
import Element.Keyed
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html
import Html.Attributes as Attr
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
import Style
import Style.Helpers as Helpers
import Time
import View.FontAwesome as FontAwesome
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
        SanityApi.Object.LiveStream.id_
        SanityApi.Object.LiveStream.createdAt_


view : LiveStream -> Element msg
view event =
    Element.column
        [ Element.spacing 20
        , Element.width (Element.fill |> Element.maximum 550)
        , Element.padding 30
        , Border.shadow { offset = ( 1, 1 ), size = 1, blur = 2, color = Element.rgba255 0 0 0 0.3 }
        ]
        [ Element.paragraph
            [ Font.bold
            , Font.size 24
            ]
            [ Element.text event.title ]
        , guestsView event.guest
        , event.project |> Maybe.map projectView |> Maybe.withDefault Element.none
        , [ Element.text event.description ] |> Element.paragraph [ Font.size 14, Element.width Element.fill ]
        , ( event.startsAt |> Time.posixToMillis |> String.fromInt
          , Html.node "intl-time" [ Attr.property "editorValue" (event.startsAt |> Time.posixToMillis |> Encode.int) ] []
                |> Element.html
          )
            |> Element.Keyed.el
                [ Font.size 20
                ]
        , Element.newTabLink []
            { url = GoogleCalendar.googleAddToCalendarLink event
            , label =
                Helpers.button
                    { fontColor = .mainBackground
                    , backgroundColor = .light
                    , size = Style.fontSize.body
                    }
                    [ Element.text "Add to Google Calendar"
                    ]
            }

        -- , TwitchButton.view
        ]


recordingView : LiveStream -> Element msg
recordingView event =
    case event.youtubeId of
        Nothing ->
            Element.none

        Just youtubeId ->
            Element.column
                [ Element.spacing 20
                , Element.width (Element.fill |> Element.maximum 550)
                , Element.padding 30
                , Border.shadow { offset = ( 1, 1 ), size = 1, blur = 2, color = Element.rgba255 0 0 0 0.3 }
                ]
                [ Youtube.view youtubeId
                , Element.paragraph
                    [ Font.bold
                    , Font.size 24
                    ]
                    [ Element.text event.title ]
                , guestsView event.guest
                , event.project |> Maybe.map projectView |> Maybe.withDefault Element.none
                , [ Element.text event.description ] |> Element.paragraph [ Font.size 14, Element.width Element.fill ]
                , Html.node "intl-time" [ Attr.property "editorValue" (event.startsAt |> Time.posixToMillis |> Encode.int) ] []
                    |> Element.html
                    |> Element.el
                        [ Font.size 20
                        ]
                ]


guestsView : List Guest -> Element msg
guestsView guests =
    Element.column [ Font.size 18, Element.spacing 15 ]
        (List.map guestView guests)


guestView guest =
    Element.row [ Element.spacing 10 ]
        [ Element.row []
            [ Element.text "Guest: " |> Element.el [ Font.color Style.color.darkGray ]
            , Element.text guest.name
            ]
        , socialBadges guest
        ]


socialBadges guest =
    Element.row [ Element.spacing 5 ]
        ([ guest.twitter
            |> Maybe.map
                (\twitter ->
                    Helpers.fontAwesomeLink { url = "https://twitter.com/" ++ twitter, name = "fab fa-twitter" }
                )
         , guest.github
            |> Maybe.map
                (\github ->
                    Helpers.fontAwesomeLink { url = "https://github.com/" ++ github, name = "fab fa-github" }
                )
         ]
            |> List.filterMap identity
        )


projectView : Project -> Element msg
projectView project =
    Element.paragraph [ Font.size 18 ]
        [ Element.text "working on "
        , Helpers.link2
            { url = "https://github.com/dillonkearns/" ++ project.name
            , content =
                Element.row [ Element.spacing 4, Font.underline ]
                    [ FontAwesome.styledIcon "fab fa-github" []
                    , Element.text project.name
                    ]
            }
        ]

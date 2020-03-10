module Request.Events exposing (..)

import Element exposing (Element)
import Element.Border as Border
import Element.Font as Font
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html
import Html.Attributes as Attr
import Json.Encode as Encode
import Request.GoogleCalendar as GoogleCalendar
import SanityApi.Object
import SanityApi.Object.Guest
import SanityApi.Object.LiveStream
import SanityApi.Object.Project
import SanityApi.Query as Query
import Scalar exposing (DateTime)
import Style
import Style.Helpers as Helpers
import Time
import TwitchButton


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
    , project : Project
    }


type alias Guest =
    { name : String
    , twitter : Maybe String
    }


guestSelection : SelectionSet Guest SanityApi.Object.Guest
guestSelection =
    SelectionSet.map2 Guest
        (SanityApi.Object.Guest.name |> SelectionSet.nonNullOrFail)
        SanityApi.Object.Guest.twitter


type alias Project =
    { name : String }


projectSelection : SelectionSet Project SanityApi.Object.Project
projectSelection =
    SelectionSet.map Project
        (SanityApi.Object.Project.name |> SelectionSet.nonNullOrFail)


liveStreamSelection : SelectionSet LiveStream SanityApi.Object.LiveStream
liveStreamSelection =
    SelectionSet.map5 LiveStream
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
            |> SelectionSet.nonNullOrFail
            |> SelectionSet.nonNullElementsOrFail
        )
        (SanityApi.Object.LiveStream.project projectSelection
            |> SelectionSet.nonNullOrFail
        )


view : LiveStream -> Element msg
view event =
    Element.column
        [ Element.spacing 20
        , Element.width (Element.fill |> Element.maximum 450)
        , Element.padding 30
        , Border.shadow { offset = ( 1, 1 ), size = 1, blur = 2, color = Element.rgba255 0 0 0 0.3 }
        ]
        [ Element.paragraph
            [ Font.bold
            , Font.size 24
            ]
            [ Element.text event.title ]
        , guestsView event.guest
        , projectView event.project
        , [ Element.text event.description ] |> Element.paragraph [ Font.size 14, Element.width Element.fill ]
        , Html.node "intl-time" [ Attr.property "editorValue" (event.startsAt |> Time.posixToMillis |> Encode.int) ] []
            |> Element.html
            |> Element.el
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


guestsView : List Guest -> Element msg
guestsView guests =
    Element.column [ Font.size 18, Element.spacing 15 ]
        (List.map guestView guests)


guestView guest =
    Element.row []
        ([ Element.text ("Guest: " ++ guest.name) |> Just
         , guest.twitter
            |> Maybe.map
                (\twitter ->
                    Helpers.fontAwesomeLink { url = "https://twitter.com/" ++ twitter, name = "fab fa-twitter" }
                )
         ]
            |> List.filterMap identity
        )


projectView : Project -> Element msg
projectView project =
    Element.paragraph [ Font.size 18 ]
        [ Element.text "working on "
        , Helpers.link { url = "https://github.com/dillonkearns/" ++ project.name, content = project.name }
        ]

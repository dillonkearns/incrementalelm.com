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
import SanityApi.Query as Query
import Scalar exposing (DateTime)
import Style
import Style.Helpers as Helpers
import Time


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
    }


type alias Guest =
    { name : String
    , twitter : String
    }


guestSelection : SelectionSet Guest SanityApi.Object.Guest
guestSelection =
    SelectionSet.map2 Guest
        (SanityApi.Object.Guest.name |> SelectionSet.nonNullOrFail)
        (SanityApi.Object.Guest.twitter |> SelectionSet.nonNullOrFail)


liveStreamSelection : SelectionSet LiveStream SanityApi.Object.LiveStream
liveStreamSelection =
    SelectionSet.map4 LiveStream
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
        , guestView event.guest
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
        ]


guestView : List Guest -> Element msg
guestView guests =
    Element.paragraph [ Font.size 18 ]
        (case guests of
            [ guest ] ->
                [ Element.text "with "
                , Helpers.link { url = "https://twitter.com/" ++ guest.twitter, content = guest.name }
                ]

            _ ->
                []
        )

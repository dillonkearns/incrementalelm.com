module Request.Events exposing (..)

import Element exposing (Element)
import Element.Font as Font
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html
import Html.Attributes as Attr
import Json.Encode as Encode
import Request.GoogleCalendar as GoogleCalendar
import SanityApi.Object
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
    }


liveStreamSelection : SelectionSet LiveStream SanityApi.Object.LiveStream
liveStreamSelection =
    SelectionSet.map3 LiveStream
        (SanityApi.Object.LiveStream.title
            |> SelectionSet.nonNullOrFail
        )
        (SanityApi.Object.LiveStream.date
            |> SelectionSet.nonNullOrFail
        )
        (SanityApi.Object.LiveStream.description
            --|> SelectionSet.nonNullOrFail
            |> SelectionSet.withDefault ""
        )


view : NamedZone -> LiveStream -> Element msg
view timezone event =
    Element.column [ Element.spacing 20 ]
        [ Element.newTabLink []
            { url = "" -- event.url
            , label =
                Element.text event.title
                    |> Element.el
                        [ Font.bold
                        , Font.size 24
                        ]
            }
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

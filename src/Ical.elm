module Ical exposing (Config, Event, Recipient, generate)

import Property exposing (Parameter(..), ValueData(..))
import Time


type alias Event =
    { stamp : Time.Posix
    , start : Time.Posix
    , end : Time.Posix
    , summary : String
    , description : String
    , location : String
    , id : String
    , organizer : Maybe Recipient
    }


type alias Recipient =
    { name : String
    , email : String

    --, mailTo : Maybe String
    }


eventGenerate : Config -> Event -> String
eventGenerate config details =
    """BEGIN:VEVENT
"""
        ++ formatKeysNew (keysNew config details)
        ++ """
END:VEVENT"""


keysNew : Config -> Event -> List ( String, ValueData, List Parameter )
keysNew config details =
    [ ( "UID", details.id ++ "@" ++ config.domain |> Text, [] )
    , ( "DTSTAMP", details.stamp |> DateTime, [] ) -- https://www.kanzaki.com/docs/ical/dtstamp.html
    , ( "DTSTART", details.start |> DateTime, [] )
    , ( "DTEND", details.end |> DateTime, [] )
    , ( "SUMMARY", details.summary |> Text, [] )
    , ( "DESCRIPTION", details.description |> Text, [] )
    , ( "LOCATION", details.location |> Text, [] )
    ]
        ++ ([ details.organizer
                |> Maybe.map
                    (\organizer ->
                        ( "ORGANIZER"
                        , CalAddress organizer.email
                        , [ Parameter ( "CN", organizer.name ) ]
                        )
                    )
            ]
                |> List.filterMap identity
           )


formatKeysNew : List ( String, ValueData, List Parameter ) -> String
formatKeysNew nodes =
    nodes
        |> List.map Property.encodeProperty
        |> String.join "\n"


type alias Config =
    { id : String
    , domain : String
    , name : Maybe String
    , description : Maybe String
    , url : Maybe String
    }


generate : Config -> List Event -> String
generate config events =
    """BEGIN:VCALENDAR
"""
        ++ calendarProperties config
        ++ "\n"
        ++ String.join "\n" (List.map (eventGenerate config) events)
        ++ """
END:VCALENDAR"""


calendarProperties : Config -> String
calendarProperties config =
    [ ( "VERSION", "2.0" |> Text, [] )
    , ( "PRODID", "-//incrementalelm.com//elm-ical.tests//EN" |> Text, [] )
    ]
        ++ ([ config.name |> Maybe.map (\name -> ( "NAME", Text name, [] ))
            , config.description |> Maybe.map (\description -> ( "DESCRIPTION", Text description, [] ))
            , config.url |> Maybe.map (\url -> ( "URL", Text url, [] ))
            ]
                |> List.filterMap identity
           )
        |> formatKeysNew

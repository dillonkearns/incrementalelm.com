module Request.GoogleCalendar exposing (Event, googleAddToCalendarLink, request)

import BackendTask exposing (BackendTask)
import BackendTask.Env
import BackendTask.Http
import Extra.Json.Decode.Exploration as Decode
import FatalError exposing (FatalError)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Rfc3339
import Time
import Time.Extra as Time
import Url.Builder


type alias Event =
    { id : String
    , summary : String
    , description : String
    , location : Maybe String
    , start : Time.Posix
    , url : String
    }


decoder : Decoder (List Event)
decoder =
    Decode.succeed Event
        |> Pipeline.required "id" Decode.string
        |> Pipeline.required "summary" Decode.string
        |> Pipeline.optional "description" Decode.string ""
        |> Pipeline.optional "location" (Decode.map Just Decode.string) Nothing
        |> Pipeline.requiredAt [ "start", "dateTime" ] Decode.iso8601
        |> Pipeline.required "htmlLink" Decode.string
        |> Decode.list
        |> Decode.field "items"


googleAddToCalendarLink event =
    Url.Builder.crossOrigin
        "http://www.google.com"
        [ "calendar", "render" ]
        [ Url.Builder.string "action" "TEMPLATE"
        , Url.Builder.string "trp" "true"
        , Url.Builder.string "text" event.title
        , Url.Builder.string "details" event.description
        , Url.Builder.string "location" "https://www.twitch.tv/dillonkearns"
        , Url.Builder.string "dates"
            (String.concat
                [ event.startsAt |> Rfc3339.format
                , "/"
                , event.startsAt |> Time.add Time.Hour 1 Time.utc |> Rfc3339.format
                ]
            )
        , Url.Builder.string "sprop" "https://incrementalelm.com"
        ]


request : BackendTask FatalError (List Event)
request =
    BackendTask.Env.expect "GOOGLE_CALENDAR_API_KEY"
        |> BackendTask.allowFatal
        |> BackendTask.andThen
            (\key ->
                BackendTask.Http.getJson
                    ("https://www.googleapis.com/calendar/v3/calendars/dillonkearns.com_4ksg89crjfvchds60t16dpqu98@group.calendar.google.com/events"
                        ++ "?orderBy=startTime"
                        ++ "&singleEvents=true"
                        ++ "&key="
                        ++ key
                    )
                    decoder
                    |> BackendTask.allowFatal
            )

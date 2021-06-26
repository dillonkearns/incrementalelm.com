module Request.GoogleCalendar exposing (Event, googleAddToCalendarLink, request)

--import Pages.StaticHttp as StaticHttp

import DataSource exposing (DataSource)
import DataSource.Http
import Extra.Json.Decode.Exploration as Decode
import OptimizedDecoder as Decode exposing (Decoder)
import OptimizedDecoder.Pipeline as Pipeline
import Pages.Secrets as Secrets
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



--googleAddToCalendarLink : Event -> String


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

        --, Url.Builder.string "ctz" "America%2FLos_Angeles"
        , Url.Builder.string "sprop" "https://incrementalelm.com"

        --"?sprop=website%3Awww.paperlesspost.com&location=Our+Apartment%2C+1731+Chapala+St%2C+Santa+Barbara%2C+CA" ]
        ]



-- location=https%3A%2F%2Ftwitch.tv%2Fjlengstorf&dates=20200303T183000Z%2F20200303T200000Z&ctz=America%2FLos_Angeles


request : DataSource (List Event)
request =
    DataSource.Http.get
        (Secrets.succeed
            (\key ->
                "https://www.googleapis.com/calendar/v3/calendars/dillonkearns.com_4ksg89crjfvchds60t16dpqu98@group.calendar.google.com/events"
                    ++ "?orderBy=startTime"
                    ++ "&singleEvents=true"
                    --++ "&timeMin="
                    --++ Url.percentEncode (String.replace ".000Z" "Z" (Iso8601.fromTime Pages.builtAt))
                    --++ "&timeMax="
                    --++ Url.percentEncode (String.replace ".000Z" "Z" (Iso8601.fromTime (Time.add Time.Month 1 Time.utc Pages.builtAt)))
                    ++ "&key="
                    ++ key
             --"https://api.github.com/repos/dillonkearns/elm-pages"
            )
            |> Secrets.with "GOOGLE_CALENDAR_API_KEY"
        )
        decoder

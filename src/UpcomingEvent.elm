module UpcomingEvent exposing (avatarUrl, dateString, encodeGuest, githubAvatarUrl, json, pacificZone)

import DateFormat
import Json.Encode as Encode
import Request.Events exposing (Guest, LiveStream)
import Time


json : LiveStream -> { path : List String, content : String }
json upcoming =
    { path = [ "live", "upcoming.json" ]
    , content =
        Encode.object
            [ ( "title", Encode.string upcoming.title )
            , ( "description", Encode.string upcoming.description )
            , ( "guest", upcoming.guest |> encodeGuest |> Encode.string )
            , ( "avatarUrl", upcoming.guest |> avatarUrl |> Encode.string )
            , ( "githubAvatarUrl", upcoming.guest |> githubAvatarUrl |> Encode.string )
            , ( "startsAt", upcoming.startsAt |> dateString |> Encode.string )
            ]
            |> Encode.encode 0
    }


dateString : Time.Posix -> String
dateString posix =
    DateFormat.format
        [ DateFormat.dayOfWeekNameFull
        , DateFormat.text ", "
        , DateFormat.monthNameFull
        , DateFormat.text " "
        , DateFormat.dayOfMonthNumber
        , DateFormat.text " @ "
        , DateFormat.hourNumber
        , DateFormat.text ":"
        , DateFormat.minuteFixed
        , DateFormat.amPmLowercase
        , DateFormat.text " PT"
        ]
        pacificZone
        posix


pacificZone : Time.Zone
pacificZone =
    Time.customZone (-60 * 7) []


avatarUrl : List Guest -> String
avatarUrl guests =
    case List.head guests of
        Just guest ->
            guest.avatarUrl |> Maybe.withDefault ""

        Nothing ->
            ""


githubAvatarUrl : List Guest -> String
githubAvatarUrl guests =
    case List.head guests of
        Just guest ->
            guest.github
                |> Maybe.map (\username -> "https://github.com/" ++ username ++ ".png")
                |> Maybe.withDefault ""

        Nothing ->
            ""


encodeGuest : List Guest -> String
encodeGuest guests =
    guests |> List.map .name |> String.join ", "

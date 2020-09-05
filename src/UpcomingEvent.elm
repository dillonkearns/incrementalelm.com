module UpcomingEvent exposing (..)

import Json.Encode as Encode
import Request.Events exposing (Guest, LiveStream)


json : LiveStream -> { path : List String, content : String }
json upcoming =
    { path = [ "live", "upcoming.json" ]
    , content =
        Encode.object
            [ ( "title", Encode.string upcoming.title )
            , ( "description", Encode.string upcoming.description )
            , ( "guest", upcoming.guest |> encodeGuest |> Encode.string )
            , ( "avatarUrl", upcoming.guest |> avatarUrl |> Encode.string )
            ]
            |> Encode.encode 0
    }


avatarUrl : List Guest -> String
avatarUrl guests =
    case List.head guests of
        Just guest ->
            guest.avatarUrl |> Maybe.withDefault ""

        Nothing ->
            ""


encodeGuest : List Guest -> String
encodeGuest guests =
    guests |> List.map .name |> String.join ", "

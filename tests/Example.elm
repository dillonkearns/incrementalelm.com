module Example exposing (suite)

import Date
import Expect
import Iso8601
import Rss exposing (DateOrTime)
import Test exposing (..)
import Time


today : Time.Posix
today =
    Iso8601.toTime "2020-09-28T14:00:00+00:00"
        --Iso8601.toTime "2020-09-28T23:00:00+00:00"
        |> okOrCrash


suite : Test
suite =
    describe "date comparison"
        [ test "publish date is tomorrow" <|
            \() ->
                onOrAfterPublishDate today
                    (Rss.Date
                        (Date.fromIsoString "2020-09-29"
                            |> okOrCrash
                        )
                    )
                    |> Expect.equal False
        , test "publish date is today" <|
            \() ->
                onOrAfterPublishDate today
                    (Rss.Date
                        (Date.fromIsoString "2020-09-28"
                            |> okOrCrash
                        )
                    )
                    |> Expect.equal True
        , test "publish date was today" <|
            \() ->
                onOrAfterPublishDate today
                    (Rss.Date
                        (Date.fromIsoString "2020-09-27"
                            |> okOrCrash
                        )
                    )
                    |> Expect.equal True
        ]


okOrCrash : Result error a -> a
okOrCrash value =
    case value of
        Ok okValue ->
            okValue

        Err err ->
            Debug.todo (Debug.toString err)


onOrAfterPublishDate : Time.Posix -> DateOrTime -> Bool
onOrAfterPublishDate now dateOrTime =
    let
        zone : Time.Zone
        zone =
            Time.utc
    in
    case dateOrTime of
        Rss.Date publishDate ->
            -- now > publishDate
            Date.compare (Date.fromPosix zone now) publishDate /= LT

        Rss.DateTime publishDateTime ->
            -- now > publishDateTime
            Date.compare (Date.fromPosix zone now) (Date.fromPosix zone publishDateTime) /= LT

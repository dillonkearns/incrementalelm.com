module Request.Events exposing (..)

import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import SanityApi.Object
import SanityApi.Object.LiveStream
import SanityApi.Query as Query
import Scalar exposing (DateTime)


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

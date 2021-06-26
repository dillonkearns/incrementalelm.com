module Scalar exposing (Date, DateTime, Id, codecs)

import Iso8601
import SanityApi.Scalar exposing (defaultCodecs)
import Time


type alias Date =
    SanityApi.Scalar.Date


type alias DateTime =
    Time.Posix


type alias Id =
    SanityApi.Scalar.Id


codecs : SanityApi.Scalar.Codecs Date DateTime Id
codecs =
    SanityApi.Scalar.defineCodecs
        { codecDate = defaultCodecs.codecDate
        , codecDateTime =
            { encoder = Iso8601.encode
            , decoder = Iso8601.decoder
            }
        , codecId = defaultCodecs.codecId
        }

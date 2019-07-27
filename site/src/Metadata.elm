module Metadata exposing (Metadata)

import Element exposing (Element)


type alias Metadata msg =
    { description : String
    , title : { styled : Element msg, raw : String }
    }

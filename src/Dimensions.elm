module Dimensions exposing (Dimensions)

import Element


type alias Dimensions =
    { width : Float
    , height : Float
    , device : Element.Device
    }

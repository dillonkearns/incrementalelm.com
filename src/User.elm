port module User exposing (User, sub)

import Json.Decode exposing (Decoder)


port gotUser : (Json.Decode.Value -> msg) -> Sub msg


sub : Sub (Maybe User)
sub =
    gotUser
        (\userJson ->
            userJson
                |> Json.Decode.decodeValue (Json.Decode.nullable userDecoder)
                |> Result.mapError Json.Decode.errorToString
                |> Result.withDefault Nothing
        )


type alias User =
    { avatarUrl : String
    , name : String
    , isPro : Bool
    }


userDecoder : Decoder User
userDecoder =
    Json.Decode.map3 User
        (Json.Decode.field "picture" Json.Decode.string)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "isPro" Json.Decode.bool)

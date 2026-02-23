module Cloudinary exposing (url)

import MimeType
import Pages.Url


url :
    String
    -> Maybe MimeType.MimeImage
    -> Int
    -> Pages.Url.Url
url asset format width =
    let
        base : String
        base =
            "https://res.cloudinary.com/dillonkearns/image/upload"

        fetch_format : String
        fetch_format =
            case format of
                Just MimeType.Png ->
                    "png"

                Just (MimeType.OtherImage "webp") ->
                    "webp"

                Just _ ->
                    "auto"

                Nothing ->
                    "auto"

        transforms : String
        transforms =
            [ "c_pad"
            , "w_" ++ String.fromInt width
            , "q_auto"
            , "f_" ++ fetch_format
            ]
                |> String.join ","
    in
    Pages.Url.external (base ++ "/" ++ transforms ++ "/" ++ asset)

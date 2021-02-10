module UnsplashImage exposing (UnsplashImage, decoder, image, imagePath, rawUrl)

import Element
import Json.Decode as Decode exposing (Decoder)
import Pages
import Pages.ImagePath as ImagePath exposing (ImagePath)
import Url.Builder exposing (string)


type UnsplashImage
    = UnsplashImage String


image :
    List (Element.Attribute msg)
    -> UnsplashImage
    -> Element.Element msg
image attrs (UnsplashImage url_) =
    Element.image attrs
        { src = url_
        , description = "Cover image"
        }


imagePath : UnsplashImage -> ImagePath Pages.PathKey
imagePath (UnsplashImage url_) =
    url_
        |> ImagePath.external


rawUrl : UnsplashImage -> String
rawUrl (UnsplashImage url_) =
    url_


decoder : Decoder UnsplashImage
decoder =
    Decode.string
        |> Decode.map url
        |> Decode.map UnsplashImage


url : String -> String
url photoId =
    Url.Builder.crossOrigin
        "https://images.unsplash.com"
        [ photoId ]
        [ string "auto" "format"
        , string "fit" "crop"
        , Url.Builder.int "w" 600
        , Url.Builder.int "q" 80
        ]

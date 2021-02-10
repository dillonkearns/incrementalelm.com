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
    -- https://images.unsplash.com/photo-1511028931355-082bb4781053
    --?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1
    --&auto=format&fit=crop&w=2551&q=80
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

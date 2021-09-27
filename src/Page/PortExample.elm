module Page.PortExample exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.Port
import Head
import Head.Seo as Seo
import Html.Attributes as Attr
import Html.Styled as Html
import Json.Encode
import OptimizedDecoder as Decode
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Shiki
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type alias Data =
    { environment : String

    --, shell : Html.Html Msg
    }


data : DataSource Data
data =
    DataSource.map Data
        (DataSource.Port.get "environmentVariable"
            (Json.Encode.string "EDITOR")
            Decode.string
        )



--(DataSource.Port.get "shell"
--    (Json.Encode.string "ls")
--    Decode.string
--    |> DataSource.andThen (shikiDataSource 2)
--)


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Placeholder"
    , body =
        View.Tailwind
            [ Html.div []
                [ Html.text static.data.environment
                ]

            --, static.data.shell
            --, [ shikiView static.data.shell ]
            ]
    }



--shikiDataSource : Int -> String -> DataSource (List String)


shikiDataSource : a -> String -> DataSource (Html.Html msg)
shikiDataSource key codeSnippet =
    DataSource.Port.get "highlight"
        (Json.Encode.string codeSnippet)
        (Shiki.decoder
            |> Decode.map
                (Shiki.view
                    [ Attr.style "font-family" "IBM Plex Mono"
                    , Attr.style "padding" "2rem"
                    ]
                )
            |> Decode.map Html.fromUnstyled
        )


type alias ShikiToken =
    { content : String
    , color : String
    , fontStyle : Int
    }


shikiTokenDecoder : Decode.Decoder ShikiToken
shikiTokenDecoder =
    Decode.map3 ShikiToken
        (Decode.field "content" Decode.string)
        (Decode.field "color" Decode.string)
        (Decode.field "fontStyle" fontStyleDecoder)


fontStyleDecoder =
    Decode.int

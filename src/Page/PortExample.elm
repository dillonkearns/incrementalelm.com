module Page.PortExample exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.Http
import DataSource.Port
import Head
import Head.Seo as Seo
import Html as PlainHtml
import Html.Attributes as Attr
import Html.Parser
import Html.Parser.Util
import Html.Styled as Html
import Json.Encode
import OptimizedDecoder as Decode
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Secrets
import Serialize
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
    { highlight : Html.Html Msg
    , environment : String

    --, shell : Html.Html Msg
    }


data : DataSource Data
data =
    DataSource.map2 Data
        (shikiDataSource 1
            """import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

main =
 Browser.sandbox { init = 0, update = update, view = view }

type Msg = Increment | Decrement

{-| <https://github.com/shikijs/shiki/blob/2a31dc50f4fbdb9a63990ccd15e08cccc9c1566a/packages/shiki/src/renderer.ts#L16>
-}

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
 case msg of
   Increment ->
     model + 1

   Decrement ->
     model - 1

view model =
 div []
   [ button [ onClick Decrement ] [ text "-" ]
   , div [] [ text (String.fromInt model) ]
   , button [ onClick Increment ] [ text "+" ]
   ]
"""
        )
        (DataSource.Port.send "environmentVariable"
            (Json.Encode.string "EDITOR")
            Decode.string
        )



--(DataSource.Port.send "shell"
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
            [ static.data.highlight

            --|> Html.Parser.Util.toVirtualDom
            --|> PlainHtml.div []
            --|> Html.fromUnstyled
            , Html.div []
                [ Html.text static.data.environment
                ]

            --, static.data.shell
            --, [ shikiView static.data.shell ]
            ]
    }


shikiView htmlString =
    htmlString
        |> Html.Parser.Util.toVirtualDom
        |> PlainHtml.div []
        |> Html.fromUnstyled



--shikiDataSource : Int -> String -> DataSource (List String)


shikiDataSource : a -> String -> DataSource (Html.Html msg)
shikiDataSource key codeSnippet =
    DataSource.Port.send "highlight"
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



--|> DataSource.distillSerializeCodec (String.fromInt key) (Serialize.list nodeCodec)
--shikiDataSource : Int -> String -> DataSource (List Html.Parser.Node)
--shikiDataSource key codeSnippet =
--    DataSource.Port.send "highlight"
--        (Json.Encode.string codeSnippet)
--        Decode.string
--        |> DataSource.andThen
--            (\htmlString ->
--                Html.Parser.run htmlString
--                    |> Result.mapError (\_ -> "HTML parsing error")
--                    |> DataSource.fromResult
--            )
--        |> DataSource.distillSerializeCodec (String.fromInt key) (Serialize.list nodeCodec)


nodeCodec : Serialize.Codec Never Html.Parser.Node
nodeCodec =
    Serialize.customType
        (\vText vElement vComment value ->
            case value of
                Html.Parser.Text string ->
                    vText string

                Html.Parser.Element nodeName attributes children ->
                    vElement nodeName attributes children

                Html.Parser.Comment string ->
                    vComment string
        )
        |> Serialize.variant1 Html.Parser.Text Serialize.string
        |> Serialize.variant3 Html.Parser.Element Serialize.string (Serialize.list (Serialize.tuple Serialize.string Serialize.string)) (Serialize.list (Serialize.lazy (\() -> nodeCodec)))
        |> Serialize.variant1 Html.Parser.Comment Serialize.string
        |> Serialize.finishCustomType

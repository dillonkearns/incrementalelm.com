module Main exposing (..)

import Animation
import Browser
import Element exposing (Element)
import Element.Background as Background
import Element.Font
import ElmLogo
import Html exposing (Html)
import Style exposing (palette)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time


type alias Model =
    { styles : List Animation.State
    }


type Msg
    = Animate Animation.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Animate time ->
            ( { model
                | styles = List.map (Animation.update time) model.styles
              }
            , Cmd.none
            )


updateStyles : Model -> Model
updateStyles model =
    { model
        | styles =
            model.styles
                |> List.indexedMap makeTranslated
    }


view : Model -> Browser.Document Msg
view model =
    { title = "Incremental Elm"
    , body = [ mainView model ]
    }


mainView model =
    [ navbar model
    , [ "Build safer frontends"
            |> Element.text
            |> Element.el
                [ Element.Font.color (Element.rgb 255 255 255)
                , Element.centerX
                , Element.centerY
                , Element.Font.size 55
                , Element.Font.family [ Element.Font.typeface "Lato" ]
                ]
      ]
        |> Element.column
            [ Background.color palette.light
            , Element.height (Element.px 300)
            , Element.width Element.fill
            ]
    ]
        |> Element.column
            [ Element.height Element.shrink
            , Element.alignTop
            , Element.width Element.fill
            ]
        |> Element.layout []


logoText =
    [ Element.text "Incremental Elm"
        |> Element.el
            [ Element.Font.color palette.bold
            , Element.Font.size 50
            ]
    , Element.text "Consulting"
        |> Element.el
            [ Element.Font.color palette.bold
            , Element.Font.size 17
            , Element.alignRight
            ]
    ]
        |> Element.column
            [ Element.Font.family []
            , Element.width Element.shrink
            , Element.height Element.shrink
            , Element.spacing 5
            ]


navbar model =
    [ animationView model
    , logoText
    ]
        |> Element.row
            [ Background.color palette.mainBackground
            , Element.alignTop
            ]


animationView model =
    svg
        [ version "1.1"
        , x "0"
        , y "0"
        , viewBox "0 0 323.141 322.95"
        , width "100%"
        ]
        [ Svg.g []
            (List.map (\poly -> polygon (Animation.render poly) []) model.styles)
        ]
        |> Element.html
        |> Element.el
            [ Element.padding 20
            , Element.height Element.shrink
            , Element.width (Element.px 100)
            , Element.alignTop
            , Element.alignLeft
            ]


translate n =
    Animation.translate (Animation.px n) (Animation.px n)


second =
    1000


makeTranslated i polygon =
    polygon
        |> Animation.interrupt
            [ Animation.set
                [ translate -1000
                , Animation.scale 1
                ]
            , Animation.wait
                (second
                    * toFloat i
                    * 0.1
                    + (((toFloat i * toFloat i) * second * 0.05) / (toFloat i + 1))
                    |> round
                    |> Time.millisToPosix
                )
            , Animation.to
                [ translate 0
                , Animation.scale 1
                ]
            ]


init : () -> ( Model, Cmd Msg )
init () =
    ( { styles = ElmLogo.polygons |> List.map Animation.style
      }
        |> updateStyles
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate model.styles


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Html.program
--     { init = init
--     , view = view
--     , update = update
--     , subscriptions = subscriptions
--     }

module Main exposing (..)

import Animation exposing (px)
import Color exposing (green, purple, rgb)
import Html exposing (Html, div, h1)
import Html.Attributes as Attr
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (second)


type alias Model =
    { styles : List Animation.State
    , index : Int
    }


type Msg
    = EverybodySwitch
    | MoveIn
    | Animate Animation.Msg


type alias Palette =
    { orange : Color.Color
    , green : Color.Color
    , lavender : Color.Color
    , blue : Color.Color
    }


palette : Palette
palette =
    { orange = rgb 216 219 226
    , green = rgb 27 27 30
    , lavender = rgb 55 63 81
    , blue = rgb 88 164 176
    }


originalPalette : Palette
originalPalette =
    { orange = rgb 240 173 0
    , green = rgb 127 209 59
    , lavender = rgb 90 99 120
    , blue = rgb 96 181 204
    }


polygons : List (List Animation.Property)
polygons =
    [ [ Animation.points
            [ ( 161.649, 152.782 )
            , ( 231.514, 82.916 )
            , ( 91.783, 82.916 )
            ]
      , Animation.fill palette.orange
      ]
    , [ Animation.points
            [ ( 8.867, 0 )
            , ( 79.241, 70.375 )
            , ( 232.213, 70.375 )
            , ( 161.838, 0 )
            ]
      , Animation.fill palette.green
      ]
    , [ Animation.points
            [ ( 323.298, 143.724 )
            , ( 323.298, 0 )
            , ( 179.573, 0 )
            ]
      , Animation.fill palette.blue
      ]
    , [ Animation.points
            [ ( 152.781, 161.649 )
            , ( 0, 8.868 )
            , ( 0, 314.432 )
            ]
      , Animation.fill palette.lavender
      ]
    , [ Animation.points
            [ ( 255.522, 246.655 )
            , ( 323.298, 314.432 )
            , ( 323.298, 178.879 )
            ]
      , Animation.fill palette.orange
      ]
    , [ Animation.points
            [ ( 161.649, 170.517 )
            , ( 8.869, 323.298 )
            , ( 314.43, 323.298 )
            ]
      , Animation.fill palette.blue
      ]
    ]


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        EverybodySwitch ->
            let
                wrappedIndex =
                    if List.length model.styles < model.index then
                        model.index - List.length model.styles
                    else
                        model.index

                newStyles =
                    List.drop wrappedIndex polygons ++ List.take wrappedIndex polygons
            in
            ( { model
                | index = wrappedIndex + 1
                , styles =
                    List.map3
                        (\i style newStyle ->
                            Animation.interrupt
                                [ Animation.wait (toFloat i * 0.05 * second)
                                , Animation.to newStyle
                                ]
                                style
                        )
                        (List.range 0 (List.length model.styles))
                        model.styles
                        newStyles
              }
            , Cmd.none
            )

        Animate time ->
            ( { model
                | styles = List.map (Animation.update time) model.styles
              }
            , Cmd.none
            )

        MoveIn ->
            ( updateStyles model, Cmd.none )


updateStyles : Model -> Model
updateStyles model =
    { model
        | styles =
            model.styles
                |> List.indexedMap makeTranslated
    }


view : Model -> Html Msg
view model =
    div
        [ onClick MoveIn
        , Attr.style [ ( "margin", "200px auto" ), ( "width", "500px" ), ( "height", "500px" ), ( "cursor", "pointer" ) ]
        ]
        [ h1 [] [ text "Click to morph!" ]
        , svg
            [ version "1.1"
            , x "0"
            , y "0"
            , viewBox "0 0 323.141 322.95"
            ]
          <|
            [ rect
                [ fill "rgb(27,27,30)"
                , x "192.99"
                , y "107.392"
                , width "107.676"
                , height "108.167"
                , transform "matrix(0.7071 0.7071 -0.7071 0.7071 186.4727 -127.2386)"
                ]
                []
            , Svg.g []
                (List.map (\poly -> polygon (Animation.render poly) []) model.styles)
            ]
        ]


translate n =
    Animation.translate (Animation.px n) (Animation.px n)


makeTranslated i polygon =
    polygon
        |> Animation.interrupt
            [ Animation.set
                [ translate -1000
                , Animation.scale 1
                ]
            , Animation.wait (Time.second * toFloat i * 0.1 + (((toFloat i * toFloat i) * Time.second * 0.05) / (toFloat i + 1)))
            , Animation.to
                [ translate 0
                , Animation.scale 1
                ]
            ]


init : ( Model, Cmd Msg )
init =
    ( { styles =
            polygons
                |> List.map Animation.style

      -- |> List.map translate
      , index = 1
      }
        |> updateStyles
    , Cmd.none
    )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions =
            \model ->
                Animation.subscription
                    Animate
                    model.styles
        }

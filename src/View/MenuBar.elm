module View.MenuBar exposing (Model, init, view)

import Animation
import Ease
import Element exposing (Element)
import Element.Background as Background
import Style exposing (fonts, palette)


type alias Model =
    { upper : Animation.State
    , middle : Animation.State
    , lower : Animation.State
    }


view : { model | menuBarAnimation : Model } -> Element msg
view model =
    Element.column [ Element.spacing 5, Element.height (Element.px 100), Element.centerX, Element.centerY ]
        [ animatedBar model .upper
        , animatedBar model .middle
        , animatedBar model .lower
        ]


init =
    { upper =
        Animation.styleWith interpolation
            [ Animation.translate (Animation.px 0) (Animation.px 0)
            , Animation.rotate (Animation.deg 0)
            ]
            |> Animation.interrupt
                [ Animation.toWith interpolation
                    [ Animation.translate (Animation.px 0) (Animation.px 7)
                    , Animation.rotate (Animation.deg 0)
                    ]
                , Animation.toWith interpolation
                    [ Animation.rotate (Animation.deg 45)
                    , Animation.translate (Animation.px 0) (Animation.px 7)
                    ]
                ]
    , middle =
        Animation.styleWith interpolation
            [ Animation.translate (Animation.px 0) (Animation.px 0)
            , Animation.rotate (Animation.deg 0)
            , Animation.opacity 99
            ]
            |> Animation.interrupt
                [ Animation.toWith interpolation
                    [ Animation.translate (Animation.px 0) (Animation.px 0)
                    , Animation.rotate (Animation.deg 0)
                    , Animation.opacity 100
                    ]
                , Animation.toWith interpolation
                    [ Animation.rotate (Animation.deg -45)
                    , Animation.translate (Animation.px 0) (Animation.px 0)
                    ]
                ]
    , lower =
        Animation.styleWith interpolation
            [ Animation.translate (Animation.px 0) (Animation.px 0)
            , Animation.rotate (Animation.deg 0)
            ]
            |> Animation.interrupt
                [ Animation.toWith interpolation
                    [ Animation.translate (Animation.px 0) (Animation.px -7)
                    , Animation.rotate (Animation.deg 0)
                    ]
                , Animation.toWith interpolation
                    [ Animation.rotate (Animation.deg -45)
                    , Animation.translate (Animation.px 0) (Animation.px -7)
                    ]
                ]
    }


animatedBar : { model | menuBarAnimation : Model } -> (Model -> Animation.State) -> Element msg
animatedBar model getTupleItem =
    Element.el
        ([ 22 |> Element.px |> Element.width
         , 2 |> Element.px |> Element.height
         , Background.color palette.bold
         ]
            ++ (model.menuBarAnimation
                    |> getTupleItem
                    |> Animation.render
                    |> List.map Element.htmlAttribute
               )
        )
        Element.none


second =
    1000


interpolation =
    Animation.easing
        { duration = second * 0.2
        , ease = Ease.inOutCubic
        }

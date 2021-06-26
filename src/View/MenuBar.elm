module View.MenuBar exposing (Model, animationStates, init, startAnimation, update, view)

import Animation exposing (Interpolation)
import Ease
import Element exposing (Element)
import Element.Background as Background
import Element.Events
import Style exposing (palette)


type alias Model =
    { upper : Animation.State
    , middle : Animation.State
    , lower : Animation.State
    }


animationStates : Model -> List Animation.State
animationStates model =
    [ model.upper, model.middle, model.lower ]


update time menuBarAnimation =
    { upper = Animation.update time menuBarAnimation.upper
    , middle = Animation.update time menuBarAnimation.middle
    , lower = Animation.update time menuBarAnimation.lower
    }


view : { model | menuBarAnimation : Model } -> msg -> Element msg
view model animationMsg =
    Element.column
        [ Element.spacing spacing
        , Element.height (Element.px 100)
        , Element.centerX
        , Element.centerY
        , Element.height Element.shrink
        , Element.Events.onClick animationMsg
        ]
        [ animatedBar model .upper
        , animatedBar model .middle
        , animatedBar model .lower
        ]


init =
    { upper =
        Animation.style
            [ Animation.translate (Animation.px 0) (Animation.px 0)
            , Animation.rotate (Animation.deg 0)
            ]

    -- |> Animation.interrupt
    --     [ Animation.toWith interpolation
    --         [ Animation.translate (Animation.px 0) (Animation.px separationLength)
    --         , Animation.rotate (Animation.deg 0)
    --         ]
    --     , Animation.toWith interpolation
    --         [ Animation.rotate (Animation.deg 45)
    --         , Animation.translate (Animation.px 0) (Animation.px separationLength)
    --         ]
    -- ]
    , middle =
        Animation.style
            [ Animation.translate (Animation.px 0) (Animation.px 0)
            , Animation.rotate (Animation.deg 0)
            , Animation.opacity 99
            ]

    -- |> Animation.interrupt
    --     [ Animation.toWith interpolation
    --         [ Animation.translate (Animation.px 0) (Animation.px 0)
    --         , Animation.rotate (Animation.deg 0)
    --         , Animation.opacity 100
    --         ]
    --     , Animation.toWith interpolation
    --         [ Animation.rotate (Animation.deg -45)
    --         , Animation.translate (Animation.px 0) (Animation.px 0)
    --         ]
    --     ]
    , lower =
        Animation.style
            [ Animation.translate (Animation.px 0) (Animation.px 0)
            , Animation.rotate (Animation.deg 0)
            ]

    -- |> Animation.interrupt
    --     [ Animation.toWith interpolation
    --         [ Animation.translate (Animation.px 0) (Animation.px -separationLength)
    --         , Animation.rotate (Animation.deg 0)
    --         ]
    --     , Animation.toWith interpolation
    --         [ Animation.rotate (Animation.deg -45)
    --         , Animation.translate (Animation.px 0) (Animation.px -separationLength)
    --         ]
    --     ]
    }


barHeight : number
barHeight =
    2


spacing : number
spacing =
    6


barWidth : number
barWidth =
    30


animatedBar : { model | menuBarAnimation : Model } -> (Model -> Animation.State) -> Element msg
animatedBar model getTupleItem =
    Element.el
        ([ barWidth |> Element.px |> Element.width
         , barHeight |> Element.px |> Element.height
         , Background.color palette.bold
         ]
            ++ (model.menuBarAnimation
                    |> getTupleItem
                    |> Animation.render
                    |> List.map Element.htmlAttribute
               )
        )
        Element.none


startAnimation { menuBarAnimation, showMenu } =
    case showMenu of
        True ->
            { upper =
                menuBarAnimation.upper
                    |> Animation.interrupt
                        [ Animation.toWith interpolation
                            [ Animation.rotate (Animation.deg 45)
                            , Animation.translate (Animation.px 0) (Animation.px separationLength)
                            ]
                        , Animation.toWith interpolation
                            [ Animation.translate (Animation.px 0) (Animation.px separationLength)
                            , Animation.rotate (Animation.deg 0)
                            ]
                        , Animation.toWith interpolation
                            [ Animation.translate (Animation.px 0) (Animation.px 0)
                            , Animation.rotate (Animation.deg 0)
                            ]
                        ]
            , middle =
                menuBarAnimation.middle
                    |> Animation.interrupt
                        [ Animation.toWith interpolation
                            [ Animation.rotate (Animation.deg -45)
                            , Animation.translate (Animation.px 0) (Animation.px 0)
                            ]
                        , Animation.toWith interpolation
                            [ Animation.translate (Animation.px 0) (Animation.px 0)
                            , Animation.rotate (Animation.deg 0)
                            , Animation.opacity 100
                            ]
                        , Animation.toWith interpolation
                            [ Animation.translate (Animation.px 0) (Animation.px 0)
                            , Animation.rotate (Animation.deg 0)
                            ]
                        ]
            , lower =
                menuBarAnimation.lower
                    |> Animation.interrupt
                        [ Animation.toWith interpolation
                            [ Animation.rotate (Animation.deg -45)
                            , Animation.translate (Animation.px 0) (Animation.px -separationLength)
                            ]
                        , Animation.toWith interpolation
                            [ Animation.translate (Animation.px 0) (Animation.px -separationLength)
                            , Animation.rotate (Animation.deg 0)
                            ]
                        , Animation.toWith interpolation
                            [ Animation.translate (Animation.px 0) (Animation.px 0)
                            , Animation.rotate (Animation.deg 0)
                            ]
                        ]
            }

        False ->
            { upper =
                menuBarAnimation.upper
                    |> Animation.interrupt
                        [ Animation.toWith interpolation
                            [ Animation.translate (Animation.px 0) (Animation.px separationLength)
                            , Animation.rotate (Animation.deg 0)
                            ]
                        , Animation.toWith interpolation
                            [ Animation.rotate (Animation.deg 45)
                            , Animation.translate (Animation.px 0) (Animation.px separationLength)
                            ]
                        ]
            , middle =
                menuBarAnimation.middle
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
                menuBarAnimation.lower
                    |> Animation.interrupt
                        [ Animation.toWith interpolation
                            [ Animation.translate (Animation.px 0) (Animation.px -separationLength)
                            , Animation.rotate (Animation.deg 0)
                            ]
                        , Animation.toWith interpolation
                            [ Animation.rotate (Animation.deg -45)
                            , Animation.translate (Animation.px 0) (Animation.px -separationLength)
                            ]
                        ]
            }


separationLength : Float
separationLength =
    barHeight + spacing


second : Float
second =
    1000


interpolation : Interpolation
interpolation =
    Animation.easing
        { duration = second * 0.2
        , ease = Ease.inOutCubic
        }

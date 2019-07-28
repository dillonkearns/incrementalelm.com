module Main exposing (main)

import Animation
import Browser
import Browser.Dom as Dom
import Browser.Events
import Browser.Navigation as Nav
import Content exposing (Content)
import Dict exposing (Dict)
import Dimensions exposing (Dimensions)
import Ease
import Element exposing (Element)
import Element.Border
import Element.Font as Font
import ElmLogo
import Json.Decode
import List.Extra
import Mark
import Mark.Error
import MarkParser
import MarkupPages
import MarkupPages.Parser exposing (PageOrPost)
import Metadata exposing (Metadata)
import RawContent
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Time
import Url exposing (Url)
import View.MenuBar
import View.Navbar


type alias Flags =
    {}


main : MarkupPages.Program Flags Model Msg (Metadata Msg) (Element Msg)
main =
    MarkupPages.program
        { init = init
        , view = pageOrPostView
        , update = update
        , subscriptions = subscriptions
        , parser = MarkParser.document
        , content = RawContent.content
        }


type alias Model =
    { menuBarAnimation : View.MenuBar.Model
    , menuAnimation : Animation.State
    , dimensions : Dimensions
    , styles : List Animation.State
    , showMenu : Bool
    }


init : MarkupPages.Flags Flags -> ( Model, Cmd Msg )
init flags =
    ( { styles = ElmLogo.polygons |> List.map Animation.style
      , menuBarAnimation = View.MenuBar.init
      , menuAnimation =
            Animation.style
                [ Animation.opacity 0
                ]
      , dimensions =
            Dimensions.init
                { width = 0
                , height = 0
                , device = Element.classifyDevice { height = 0, width = 0 }
                }
      , showMenu = False
      }
    , Dom.getViewport
        |> Task.perform InitialViewport
    )


type Msg
    = StartAnimation
      -- | Animate Animation.Msg
    | InitialViewport Dom.Viewport
    | WindowResized Int Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InitialViewport { viewport } ->
            ( { model
                | dimensions =
                    Dimensions.init
                        { width = viewport.width
                        , height = viewport.height
                        , device =
                            Element.classifyDevice
                                { height = round viewport.height
                                , width = round viewport.width
                                }
                        }
              }
            , Cmd.none
            )

        WindowResized width height ->
            ( { model
                | dimensions =
                    Dimensions.init
                        { width = toFloat width
                        , height = toFloat height
                        , device = Element.classifyDevice { height = height, width = width }
                        }
              }
            , Cmd.none
            )

        StartAnimation ->
            case model.showMenu of
                True ->
                    ( { model
                        | showMenu = False
                        , menuBarAnimation = View.MenuBar.startAnimation model
                        , menuAnimation =
                            model.menuAnimation
                                |> Animation.interrupt
                                    [ Animation.toWith interpolation
                                        [ Animation.opacity 100
                                        ]
                                    ]
                      }
                    , Cmd.none
                    )

                False ->
                    ( { model
                        | showMenu = True
                        , menuBarAnimation = View.MenuBar.startAnimation model
                        , menuAnimation =
                            model.menuAnimation
                                |> Animation.interrupt
                                    [ Animation.toWith interpolation
                                        [ Animation.opacity 100
                                        ]
                                    ]
                      }
                    , Cmd.none
                    )



-- Animate time ->
--     ( { model
--         | styles = List.map (Animation.update time) model.styles
--         , menuBarAnimation = View.MenuBar.update time model.menuBarAnimation
--         , menuAnimation = Animation.update time model.menuAnimation
--       }
--     , Cmd.none
--     )


interpolation =
    Animation.easing
        { duration = second * 1
        , ease = Ease.inOutCubic
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    -- Sub.batch
    --     [ Animation.subscription Animate
    --         (model.styles
    --             ++ View.MenuBar.animationStates model.menuBarAnimation
    --             ++ [ model.menuAnimation ]
    --         )
    -- ,
    Browser.Events.onResize WindowResized


header : Model -> Element Msg
header model =
    View.Navbar.view model animationView StartAnimation


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
            , Element.alignTop
            , Element.alignLeft
            , Element.width (Element.px 100)
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


pageOrPostView : Model -> PageOrPost (Metadata Msg) (Element Msg) -> { title : String, body : Element Msg }
pageOrPostView model pageOrPost =
    case pageOrPost.metadata of
        Metadata.Page metadata ->
            { title = metadata.title
            , body =
                [ header model
                , pageOrPost.view
                    |> Element.textColumn
                        [ Element.centerX
                        , Element.width Element.fill
                        , Element.spacing 30
                        , Font.size 18
                        ]
                    |> Element.el
                        [ if Dimensions.isMobile model.dimensions then
                            Element.width (Element.fill |> Element.maximum 600)

                          else
                            Element.width (Element.fill |> Element.maximum 700)
                        , Element.height Element.fill
                        , Element.padding 20
                        , Element.spacing 20
                        , Element.centerX
                        ]
                ]
                    |> Element.column [ Element.width Element.fill ]
            }

        Metadata.Article metadata ->
            { title = metadata.title.raw
            , body =
                [ header model
                , pageOrPost.view
                    |> Element.textColumn
                        [ Element.centerX
                        , Element.width Element.fill
                        , Element.spacing 30
                        , Font.size 18
                        ]
                    |> Element.el
                        [ if Dimensions.isMobile model.dimensions then
                            Element.width (Element.fill |> Element.maximum 600)

                          else
                            Element.width (Element.fill |> Element.maximum 700)
                        , Element.height Element.fill
                        , Element.padding 20
                        , Element.spacing 20
                        , Element.centerX
                        ]
                ]
                    |> Element.column [ Element.width Element.fill ]
            }

        Metadata.Learn metadata ->
            { title = metadata.title
            , body =
                [ header model
                , pageOrPost.view
                    |> Element.textColumn
                        [ Element.centerX
                        , Element.width Element.fill
                        , Element.spacing 30
                        , Font.size 18
                        ]
                    |> Element.el
                        [ if Dimensions.isMobile model.dimensions then
                            Element.width (Element.fill |> Element.maximum 600)

                          else
                            Element.width (Element.fill |> Element.maximum 700)
                        , Element.height Element.fill
                        , Element.padding 20
                        , Element.spacing 20
                        , Element.centerX
                        ]
                ]
                    |> Element.column [ Element.width Element.fill ]
            }

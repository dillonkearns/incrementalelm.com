port module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Animation exposing (Interpolation)
import Browser.Dom as Dom
import Browser.Events
import Browser.Navigation
import Css
import DarkMode exposing (DarkMode)
import DataSource
import Dimensions exposing (Dimensions)
import Ease
import Element
import ElmLogo
import Html exposing (Html)
import Html.Styled exposing (div)
import Html.Styled.Attributes exposing (css)
import Http
import Json.Decode
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import SharedTemplate exposing (SharedTemplate)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import Task
import Time
import TwitchButton
import View exposing (View)
import View.MenuBar
import View.Navbar
import View.TailwindNavbar


port toggleDarkMode : () -> Cmd msg


template : SharedTemplate Msg Model Data SharedMsg msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    , sharedMsg = SharedMsg
    }


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { menuBarAnimation : View.MenuBar.Model
    , menuAnimation : Animation.State
    , dimensions : Dimensions
    , styles : List Animation.State
    , showMenu : Bool
    , isOnAir : TwitchButton.IsOnAir
    , now : Maybe Time.Posix
    , darkMode : DarkMode
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
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
      , isOnAir = TwitchButton.notOnAir
      , now = Nothing
      , darkMode =
            case flags of
                Pages.Flags.BrowserFlags value ->
                    Json.Decode.decodeValue (Json.Decode.field "darkMode" DarkMode.darkModeDecoder) value
                        |> Result.withDefault DarkMode.Light

                Pages.Flags.PreRenderFlags ->
                    DarkMode.Light
      }
        |> updateStyles
    , Cmd.batch
        [ Dom.getViewport
            |> Task.perform InitialViewport
        , TwitchButton.request |> Cmd.map OnAirUpdated
        , Time.now |> Task.perform GotCurrentTime
        ]
    )


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


updateStyles : Model -> Model
updateStyles model =
    { model
        | styles =
            model.styles
                |> List.indexedMap makeTranslated
    }



--update : Msg -> Model -> ( Model, Cmd Msg )
--update msg model =
--    case msg of
--        OnPageChange _ ->
--            ( { model | showMobileMenu = False }, Cmd.none )
--
--        SharedMsg globalMsg ->
--            ( model, Cmd.none )
--subscriptions : Path -> Model -> Sub Msg
--subscriptions _ _ =
--    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


view :
    Data
    ->
        { path : Path
        , frontmatter : route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view sharedData page model toMsg pageView =
    case pageView.body of
        View.ElmUi elements ->
            { title = pageView.title
            , body =
                (if model.showMenu then
                    Element.column
                        [ Element.height Element.fill
                        , Element.alignTop
                        , Element.width Element.fill
                        ]
                        [ View.Navbar.view model animationView (toMsg StartAnimation)
                        , View.Navbar.modalMenuView model.menuAnimation
                        ]

                 else
                    Element.column [ Element.width Element.fill ]
                        [ View.Navbar.view model animationView (toMsg StartAnimation)
                        , elements
                            |> Element.textColumn
                                [ Element.height Element.fill
                                , Element.padding 30
                                , Element.spacing 30
                                , Element.centerX
                                , if Dimensions.isMobile model.dimensions then
                                    Element.width (Element.fill |> Element.maximum 600)

                                  else
                                    Element.width (Element.fill |> Element.maximum 700)
                                ]
                        ]
                )
                    |> Element.layout [ Element.width Element.fill ]
            }

        View.Tailwind nodes ->
            { title = pageView.title
            , body =
                div
                    [ css
                        [ Tw.min_h_screen
                        , Tw.w_full
                        , Tw.relative
                        , Tw.bg_background
                        ]
                    ]
                    [ View.TailwindNavbar.view model.darkMode ToggleDarkMode ToggleMobileMenu page.path |> Html.Styled.map toMsg
                    , div
                        [ css
                            [ Tw.pt_32
                            , Tw.pb_16
                            , Tw.px_8
                            , Tw.flex
                            , Tw.flex_col
                            , Tw.text_foreground
                            ]
                        ]
                        [ div
                            [ css
                                [ Bp.md [ Tw.mx_auto ]
                                ]
                            ]
                            [ div
                                [ css
                                    [ Tw.text_foreground
                                    , Css.fontFamilies [ "Open Sans" ]
                                    , Tw.max_w_prose
                                    , Tw.leading_7
                                    ]
                                ]
                                nodes
                            ]
                        ]
                    ]
                    |> Html.Styled.toUnstyled
            }


animationView model =
    svg
        [ version "1.1"
        , x "0"
        , y "0"
        , viewBox "0 0 323.141 322.95"
        , width "100%"
        ]
        [ g []
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


type Msg
    = StartAnimation
    | Animate Animation.Msg
    | InitialViewport Dom.Viewport
    | ToggleDarkMode
    | ToggleMobileMenu
    | WindowResized Int Int
    | OnAirUpdated (Result Http.Error TwitchButton.IsOnAir)
    | GotCurrentTime Time.Posix
    | OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleDarkMode ->
            ( model, toggleDarkMode () )

        ToggleMobileMenu ->
            ( { model | showMenu = not model.showMenu }, Cmd.none )

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

        Animate time ->
            ( { model
                | styles = List.map (Animation.update time) model.styles
                , menuBarAnimation = View.MenuBar.update time model.menuBarAnimation
                , menuAnimation = Animation.update time model.menuAnimation
              }
            , Cmd.none
            )

        OnPageChange _ ->
            ( { model
                | showMenu = False
                , menuBarAnimation = View.MenuBar.init
              }
            , Cmd.none
            )

        OnAirUpdated result ->
            case result of
                Ok isOnAir ->
                    ( { model | isOnAir = isOnAir }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        GotCurrentTime posix ->
            ( { model | now = Just posix }, Cmd.none )

        SharedMsg sharedMsg ->
            case sharedMsg of
                NoOp ->
                    ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ model =
    Sub.batch
        [ Animation.subscription Animate
            (model.styles
                ++ View.MenuBar.animationStates model.menuBarAnimation
                ++ [ model.menuAnimation ]
            )
        , Browser.Events.onResize WindowResized

        --, Time.every (oneSecond * 60) GotCurrentTime
        ]


interpolation : Interpolation
interpolation =
    Animation.easing
        { duration = second * 1
        , ease = Ease.inOutCubic
        }

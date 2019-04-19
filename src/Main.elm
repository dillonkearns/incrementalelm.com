port module Main exposing (main)

import Animation exposing (backgroundColor)
import Browser
import Browser.Dom as Dom
import Browser.Events
import Browser.Navigation
import Dimensions exposing (Dimensions)
import Ease
import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Element.Lazy
import ElmLogo
import Html exposing (Html)
import Page
import Page.Article
import Page.CaseStudies
import Page.Coaches
import Page.Contact
import Page.Events
import Page.Feedback
import Page.HomeOld
import Page.Intros
import Page.Learn
import Page.Signup
import Route exposing (Route)
import Style exposing (fonts, palette)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Time
import Url exposing (Url)
import Url.Builder
import Url.Parser exposing (Parser)
import View.MenuBar
import View.Navbar


port pageChanged : () -> Cmd msg


type alias Model =
    { styles : List Animation.State
    , menuBarAnimation : View.MenuBar.Model
    , menuAnimation : Animation.State
    , dimensions : Dimensions
    , page : Maybe Route
    , key : Browser.Navigation.Key
    , showMenu : Bool
    }


type Msg
    = Animate Animation.Msg
    | InitialViewport Dom.Viewport
    | WindowResized Int Int
    | UrlChanged Url
    | UrlRequest Browser.UrlRequest
    | StartAnimation
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Animate time ->
            ( { model
                | styles = List.map (Animation.update time) model.styles
                , menuBarAnimation = View.MenuBar.update time model.menuBarAnimation
                , menuAnimation = Animation.update time model.menuAnimation
              }
            , Cmd.none
            )

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

        UrlChanged url ->
            ( { model | page = Route.parse url }, Cmd.batch [ resetViewport, pageChanged () ] )

        UrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( { model
                        | showMenu = False
                        , menuBarAnimation = View.MenuBar.init
                      }
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Browser.Navigation.load href )

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

        NoOp ->
            ( model, Cmd.none )


updateStyles : Model -> Model
updateStyles model =
    { model
        | styles =
            model.styles
                |> List.indexedMap makeTranslated
    }


view : Model -> Browser.Document Msg
view ({ page } as model) =
    { title = Route.title page
    , body = [ mainView model ]
    }


mainView : Model -> Html Msg
mainView ({ page } as model) =
    (if model.showMenu then
        Element.column
            [ Element.height Element.fill
            , Element.alignTop
            , Element.width Element.fill
            ]
            [ View.Navbar.view model animationView StartAnimation
            , View.Navbar.modalMenuView model.menuAnimation
            ]

     else
        case page of
            Just Route.Coaches ->
                Element.column
                    [ Element.height Element.fill
                    , Element.alignTop
                    , Element.width Element.fill
                    ]
                    [ View.Navbar.view model animationView StartAnimation
                    , Page.Coaches.view model.dimensions
                    ]

            Just Route.Intros ->
                Element.column
                    [ Element.height Element.fill
                    , Element.alignTop
                    , Element.width Element.fill
                    ]
                    [ View.Navbar.view model animationView StartAnimation
                    , Page.Intros.view model.dimensions
                    ]

            Just Route.CaseStudies ->
                Element.column
                    [ Element.height Element.fill
                    , Element.alignTop
                    , Element.width Element.fill
                    ]
                    [ View.Navbar.view model animationView StartAnimation
                    , Page.CaseStudies.view model.dimensions
                    ]

            Just (Route.Signup signupDetails) ->
                Element.column
                    [ Element.height Element.fill
                    , Element.alignTop
                    , Element.width Element.fill
                    ]
                    [ View.Navbar.view model animationView StartAnimation
                    , Page.Signup.view signupDetails model.dimensions
                    ]

            Just Route.Events ->
                Element.column
                    [ Element.height Element.fill
                    , Element.alignTop
                    , Element.width Element.fill
                    ]
                    [ View.Navbar.view model animationView StartAnimation
                    , Page.Events.view model.dimensions
                    ]

            Just Route.Feedback ->
                Element.column
                    [ Element.height Element.fill
                    , Element.alignTop
                    , Element.width Element.fill
                    ]
                    [ View.Navbar.view model animationView StartAnimation
                    , Page.Feedback.view model.dimensions
                    ]

            Just (Route.Learn maybeLearnTitle) ->
                Element.column
                    [ Element.height Element.fill
                    , Element.alignTop
                    , Element.width Element.fill
                    ]
                    [ View.Navbar.view model animationView StartAnimation
                    , Element.Lazy.lazy2 Page.Learn.view model.dimensions maybeLearnTitle
                    ]

            Just (Route.Article maybePostTitle) ->
                Element.column
                    [ Element.height Element.fill
                    , Element.alignTop
                    , Element.width Element.fill
                    ]
                    [ View.Navbar.view model animationView StartAnimation
                    , Element.Lazy.lazy2 Page.Article.view model.dimensions maybePostTitle
                    ]

            Just (Route.CustomPage thePage) ->
                Element.column
                    [ Element.height Element.shrink
                    , Element.alignTop
                    , Element.width Element.fill
                    ]
                    (View.Navbar.view model animationView StartAnimation
                        :: [ Element.Lazy.lazy2 Page.view thePage model.dimensions ]
                    )

            Just Route.HomeOld ->
                Element.column
                    [ Element.height Element.shrink
                    , Element.alignTop
                    , Element.width Element.fill
                    ]
                    (View.Navbar.view model animationView StartAnimation
                        :: Page.HomeOld.view model.dimensions
                    )

            Nothing ->
                Element.text "Page not found!"
    )
        |> layout model


resetViewport : Cmd Msg
resetViewport =
    Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)


interpolation =
    Animation.easing
        { duration = second * 1
        , ease = Ease.inOutCubic
        }


layout model =
    Element.layout
        (if model.showMenu then
            []

         else
            []
        )


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


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url navigationKey =
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
      , page = Route.parse url
      , key = navigationKey
      , showMenu = False
      }
        |> updateStyles
    , Dom.getViewport
        |> Task.perform InitialViewport
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Animation.subscription Animate
            (model.styles
                ++ View.MenuBar.animationStates model.menuBarAnimation
                ++ [ model.menuAnimation ]
            )
        , Browser.Events.onResize WindowResized
        ]


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequest
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

module Shared exposing (..)

import Animation
import Browser.Dom as Dom
import Dimensions exposing (Dimensions)
import Ease
import Element exposing (Element)
import ElmLogo
import Html exposing (Html)
import Http
import Pages
import Pages.PagePath exposing (PagePath)
import Pages.StaticHttp as StaticHttp
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Time
import TwitchButton
import View.MenuBar
import View.Navbar


type SharedMsg
    = NoOp


staticData : a -> StaticHttp.Request StaticData
staticData siteMetadata =
    StaticHttp.succeed ()



--init : a -> ( Model, Cmd Msg )
--init maybePagePath =
--    ( { showMobileMenu = False
--      , counter = 0
--      }
--    , Cmd.none
--    )


init : a -> ( Model, Cmd Msg )
init initialPage =
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


type alias Model =
    { menuBarAnimation : View.MenuBar.Model
    , menuAnimation : Animation.State
    , dimensions : Dimensions
    , styles : List Animation.State
    , showMenu : Bool
    , isOnAir : TwitchButton.IsOnAir
    , now : Maybe Time.Posix
    }


map : (msg1 -> msg2) -> PageView msg1 -> PageView msg2
map fn doc =
    { title = doc.title
    , body = Element.map fn doc.body
    }


type alias RenderedBody =
    --( MarkdownRenderer.TableOfContents, List (Element Never) )
    List (Element Never)


type alias PageView msg =
    { title : String, body : Element msg }



--type alias PageView msg =
--    List (Element msg)


type alias StaticData =
    ()



--view :
--    StaticData
--    -> { a | path : PagePath Pages.PathKey }
--    -> Model
--    -> (Msg -> msg)
--    -> PageView msg
--    -> { body : Html msg, title : String }
--view stars page model toMsg pageView =
--    { body =
--        (if model.showMobileMenu then
--            Element.column
--                [ Element.width Element.fill
--                , Element.padding 20
--                ]
--                [ Element.row [ Element.width Element.fill, Element.spaceEvenly ]
--                    [ logoLinkMobile |> Element.map toMsg
--                    , FontAwesome.styledIcon "fas fa-bars" [ Element.Events.onClick ToggleMobileMenu ]
--                        |> Element.map toMsg
--                    ]
--                , Element.column [ Element.centerX, Element.spacing 20 ]
--                    (navbarLinks stars page.path)
--                ]
--
--         else
--            Element.column [ Element.width Element.fill ]
--                [ header stars page.path |> Element.map toMsg
--                , incrementView model |> Element.map toMsg
--                , pageView.body
--                ]
--        )
--            |> Element.layout
--                [ Element.width Element.fill
--                , Font.size 20
--                , Font.family [ Font.typeface "Roboto" ]
--                , Font.color (Element.rgba255 0 0 0 0.8)
--                ]
--    , title = pageView.title
--    }


view :
    StaticData
    -> { a | path : PagePath Pages.PathKey }
    -> Model
    -> (Msg -> msg)
    -> PageView msg
    -> { body : Html msg, title : String }
view allMetadata page model toMsg viewForPage =
    --        --(\events ->
    --        --    {
    --                \model viewForPage ->
    --                    let
    --                        { title, body } =
    --                            pageOrPostView allMetadata model page viewForPage
    --                    in
    --                    { title = title
    --                    , body =
    --                        (if model.showMenu then
    --                            Element.column
    --                                [ Element.height Element.fill
    --                                , Element.alignTop
    --                                , Element.width Element.fill
    --                                ]
    --                                [ View.Navbar.view model animationView StartAnimation
    --                                , View.Navbar.modalMenuView model.menuAnimation
    --                                ]
    --
    --                         else
    --                            Element.column
    --                                --[ Element.width (Element.fill |> Element.maximum 600)
    --                                [ Element.width Element.fill
    --                                ]
    --                                [ body
    --                                , eventsView model.now model.isOnAir events
    --                                ]
    --                        )
    --                            |> Element.layout
    --                                [ Element.width Element.fill
    --                                ]
    --                    }
    --
    --        --)
    --        --(Request.staticGraphqlRequest Request.Events.selection)
    --
    --else
    --        --{
    --let
    --    { title, body } =
    --        --pageOrPostView allMetadata model page viewForPage
    --        viewForPage
    --in
    { title = viewForPage.title
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
            viewForPage.body
        )
            |> Element.layout
                [ Element.width Element.fill
                ]
    }


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


type Msg
    = StartAnimation
    | Animate Animation.Msg
    | InitialViewport Dom.Viewport
    | WindowResized Int Int
    | OnPageChange
    | OnAirUpdated (Result Http.Error TwitchButton.IsOnAir)
    | GotCurrentTime Time.Posix
    | SharedMsg SharedMsg


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

        Animate time ->
            ( { model
                | styles = List.map (Animation.update time) model.styles
                , menuBarAnimation = View.MenuBar.update time model.menuBarAnimation
                , menuAnimation = Animation.update time model.menuAnimation
              }
            , Cmd.none
            )

        OnPageChange ->
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


interpolation =
    Animation.easing
        { duration = second * 1
        , ease = Ease.inOutCubic
        }

module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import BackendTask exposing (BackendTask)
import DarkMode exposing (DarkMode)
import Effect exposing (Effect)
import FatalError exposing (FatalError)
import Html exposing (Html, div)
import Html.Attributes as Attr
import Http
import Json.Decode exposing (Decoder)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Tailwind as Tw exposing (classes)
import Tailwind.Breakpoints exposing (md)
import Tailwind.Theme exposing (background, s8, s16, s32)
import Task
import Time
import TwitchButton
import UrlPath exposing (UrlPath)
import User exposing (User)
import View exposing (View)
import View.TailwindNavbar


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type alias Data =
    ()


type alias Model =
    { showMenu : Bool
    , isOnAir : TwitchButton.IsOnAir
    , now : Maybe Time.Posix
    , darkMode : DarkMode
    , user : Maybe User
    }


type SharedMsg
    = NoOp


init :
    Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : UrlPath
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Effect Msg )
init flags maybePagePath =
    ( { showMenu = False
      , isOnAir = TwitchButton.notOnAir
      , now = Nothing
      , darkMode =
            case flags of
                Pages.Flags.BrowserFlags value ->
                    Json.Decode.decodeValue (Json.Decode.field "darkMode" DarkMode.darkModeDecoder) value
                        |> Result.withDefault DarkMode.Light

                Pages.Flags.PreRenderFlags ->
                    DarkMode.Light
      , user = Nothing
      }
    , Effect.batch
        [ Effect.fromCmd (TwitchButton.request |> Cmd.map OnAirUpdated)
        , Effect.fromCmd (Time.now |> Task.perform GotCurrentTime)
        ]
    )


data : BackendTask FatalError Data
data =
    BackendTask.succeed ()


view :
    Data
    ->
        { path : UrlPath
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : List (Html msg), title : String }
view sharedData page model toMsg pageView =
    case pageView.body of
        View.Tailwind nodes ->
            { title = pageView.title
            , body =
                [ div
                    [ classes
                        [ Tw.raw "min-h-screen"
                        , Tw.w_full
                        , Tw.relative
                        , Tw.bg_simple background
                        ]
                    ]
                    [ View.TailwindNavbar.view model.user model.darkMode ToggleDarkMode ToggleMobileMenu page.path |> Html.map toMsg
                    , div
                        [ classes
                            [ Tw.pt s32
                            , Tw.pb s16
                            , Tw.px s8
                            , Tw.flex
                            , Tw.flex_col
                            , Tw.raw "text-foreground"
                            , Tw.items_center
                            ]
                        ]
                        [ div
                            [ classes
                                [ Tw.raw "max-w-prose"
                                , Tw.w_full
                                , md [ Tw.raw "mx-auto" ]
                                ]
                            ]
                            [ div
                                [ classes
                                    [ Tw.raw "text-foreground"
                                    , Tw.raw "font-open-sans"
                                    , Tw.raw "leading-7"
                                    , Tw.flex
                                    , Tw.flex_col
                                    ]
                                ]
                                nodes
                            ]
                        ]
                    ]
                ]
            }


type Msg
    = ToggleDarkMode
    | ToggleMobileMenu
    | OnAirUpdated (Result Http.Error TwitchButton.IsOnAir)
    | GotCurrentTime Time.Posix
    | GotUser (Maybe User)
    | OnPageChange
        { path : UrlPath
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ToggleDarkMode ->
            ( model, Effect.ToggleDarkMode )

        ToggleMobileMenu ->
            ( { model | showMenu = not model.showMenu }, Effect.none )

        OnPageChange _ ->
            ( { model
                | showMenu = False
              }
            , Effect.none
            )

        OnAirUpdated result ->
            case result of
                Ok isOnAir ->
                    ( { model | isOnAir = isOnAir }, Effect.none )

                Err _ ->
                    ( model, Effect.none )

        GotCurrentTime posix ->
            ( { model | now = Just posix }, Effect.none )

        GotUser maybeUser ->
            ( { model | user = maybeUser }, Effect.none )

        SharedMsg _ ->
            ( model, Effect.none )


subscriptions : UrlPath -> Model -> Sub Msg
subscriptions _ model =
    Sub.batch
        [ User.sub
            |> Sub.map GotUser
        ]

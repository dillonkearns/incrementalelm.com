port module Shared exposing (Data, Model, Msg(..), template)

import Browser.Navigation
import Css
import DarkMode exposing (DarkMode)
import DataSource
import Html exposing (Html)
import Html.Styled exposing (div)
import Html.Styled.Attributes as Attr exposing (css)
import Http
import Json.Decode exposing (Decoder)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import Task
import Time
import TwitchButton
import User exposing (User)
import View exposing (View)
import View.TailwindNavbar


port toggleDarkMode : () -> Cmd msg


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
      --|> updateStyles
    , Cmd.batch
        [ --Dom.getViewport
          --    |> Task.perform InitialViewport
          TwitchButton.request |> Cmd.map OnAirUpdated
        , Time.now |> Task.perform GotCurrentTime
        ]
    )



--updateStyles : Model -> Model
--updateStyles model =
--    { model
--        | styles =
--            model.styles
--                |> List.indexedMap makeTranslated
--    }
--update : Msg -> Model -> ( Model, Cmd Msg )
--update msg model =
--    case msg of
--        OnPageChange _ ->
--            ( { model | showMobileMenu = False }, Cmd.none )
--
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
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view sharedData page model toMsg pageView =
    case pageView.body of
        View.ElmUi _ ->
            { title = pageView.title
            , body =
                Html.div [] []
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
                    [ View.TailwindNavbar.view model.user model.darkMode ToggleDarkMode ToggleMobileMenu page.path |> Html.Styled.map toMsg
                    , div
                        [ css
                            [ Tw.pt_32
                            , Tw.pb_16
                            , Tw.px_8
                            , Tw.flex
                            , Tw.flex_col
                            , Tw.text_foreground
                            , Tw.items_center
                            ]
                        ]
                        [ div
                            [ css
                                [ Tw.max_w_prose
                                , Tw.w_full
                                , Bp.md [ Tw.mx_auto ]
                                ]
                            ]
                            [ div
                                [ css
                                    [ Tw.text_foreground
                                    , Css.fontFamilies [ "Open Sans" ]
                                    , Tw.leading_7
                                    , Tw.flex
                                    , Tw.flex_col
                                    ]
                                ]
                                nodes
                            ]
                        ]
                    ]
                    |> Html.Styled.toUnstyled
            }


type Msg
    = ToggleDarkMode
    | ToggleMobileMenu
    | OnAirUpdated (Result Http.Error TwitchButton.IsOnAir)
    | GotCurrentTime Time.Posix
    | GotUser (Maybe User)
    | OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleDarkMode ->
            ( model, toggleDarkMode () )

        ToggleMobileMenu ->
            ( { model | showMenu = not model.showMenu }, Cmd.none )

        OnPageChange _ ->
            ( { model
                | showMenu = False
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

        GotUser maybeUser ->
            ( { model | user = maybeUser }, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ model =
    Sub.batch
        [ --, Time.every (oneSecond * 60) GotCurrentTime
          User.sub
            |> Sub.map GotUser
        ]

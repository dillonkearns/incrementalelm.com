module Main exposing (main)

import Animation
import Browser
import Browser.Navigation as Nav
import Content exposing (Content)
import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Border
import Element.Font as Font
import ElmLogo
import List.Extra
import Mark
import Mark.Error
import MarkParser
import RawContent
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time
import Url exposing (Url)
import View.MenuBar
import View.Navbar


type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , menuBarAnimation : View.MenuBar.Model
    , menuAnimation : Animation.State
    , dimensions : Dimensions
    , styles : List Animation.State
    }


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key
      , url = url
      , styles = ElmLogo.polygons |> List.map Animation.style
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
      }
    , Cmd.none
    )


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | StartAnimation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        StartAnimation ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Browser.Document Msg
view model =
    let
        { title, body } =
            mainView model
    in
    { title = title
    , body =
        [ body
            |> Element.layout
                [ Element.width Element.fill
                ]
        ]
    }


mainView : Model -> { title : String, body : Element Msg }
mainView model =
    case RawContent.content of
        Ok site ->
            pageView model site

        Err errorView ->
            { title = "Error parsing"
            , body = errorView
            }


pageView : Model -> Content Msg -> { title : String, body : Element Msg }
pageView model content =
    case Content.lookup content model.url of
        Just pageOrPost ->
            { title = pageOrPost.metadata.title.raw
            , body =
                (header model :: pageOrPost.body)
                    |> Element.textColumn [ Element.width Element.fill ]
            }

        Nothing ->
            { title = "Page not found"
            , body =
                Element.column []
                    [ Element.text "Page not found. Valid routes:\n\n"
                    , (content.pages ++ content.posts)
                        |> List.map Tuple.first
                        |> List.map (String.join "/")
                        |> String.join ", "
                        |> Element.text
                    ]
            }


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



-- Element.row [ Element.padding 20, Element.Border.width 2, Element.spaceEvenly ]
--     [ Element.el [ Font.size 30 ]
--         (Element.link [] { url = "/", label = Element.text "elm-markup-site" })
--     , Element.row [ Element.spacing 15 ]
--         [ Element.link [] { url = "/articles", label = Element.text "Articles" }
--         , Element.link [] { url = "/about", label = Element.text "About" }
--         ]
--     ]

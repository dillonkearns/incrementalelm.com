module Main exposing (main)

import Animation
import Browser.Dom as Dom
import Browser.Events
import Color
import Dimensions exposing (Dimensions)
import Ease
import Element exposing (Element)
import Element.Font as Font
import ElmLogo
import GlossaryIndex
import Head as Head exposing (Tag)
import Head.Seo
import Http
import IcalFeed
import Index
import LearnIndex
import MarkdownRenderer
import MarkdownToHtmlStringRenderer
import Pages
import Pages.ImagePath as ImagePath
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Platform exposing (Page)
import Pages.StaticHttp as StaticHttp
import Palette
import Request
import Request.Events exposing (LiveStream)
import Rss
import RssPlugin
import Site
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task exposing (Task)
import TemplateDemultiplexer
import TemplateType exposing (TemplateType)
import Time
import TwitchButton
import UpcomingEvent
import View.MenuBar
import View.Navbar
import Widget.Signup



--main : Pages.Platform.Program Model Msg TemplateType (List (Element Msg))


main =
    TemplateDemultiplexer.mainTemplate
        { --init = init
          --, view = view
          --, update = update
          subscriptions = Sub.none -- \_ _ -> subscriptions
        , documents =
            [ { extension = "md"
              , metadata = TemplateType.decoder
              , body = MarkdownRenderer.view
              }
            ]
        , site = Site.config

        --, manifest = manifest
        --, canonicalSiteUrl = Site.canonicalUrl
        , onPageChange = Just (\_ -> OnPageChange)

        --, internals = Pages.internals
        }
        |> Pages.Platform.withFileGenerator
            (\_ ->
                StaticHttp.map
                    (\events ->
                        [ Ok
                            { path = [ "live.ics" ]
                            , content = IcalFeed.feed events
                            }
                        , events
                            |> List.sortBy
                                (\event ->
                                    Time.posixToMillis event.startsAt
                                )
                            |> List.reverse
                            |> List.head
                            |> Maybe.map
                                (\upcoming ->
                                    UpcomingEvent.json upcoming
                                )
                            |> (\json ->
                                    case json of
                                        Just value ->
                                            Ok value

                                        Nothing ->
                                            Err "No upcoming events found."
                               )
                        ]
                    )
                    (Request.staticGraphqlRequest Request.Events.selection)
            )
        |> RssPlugin.generate
            { siteTagline = siteTagline
            , siteUrl = Site.canonicalUrl
            , title = "Incremental Elm Tips"
            , builtAt = Pages.builtAt
            , indexPage = Pages.pages.tips
            , now = Pages.builtAt
            }
            metadataToRssItem
        |> Pages.Platform.toProgram


metadataToRssItem :
    { path : PagePath Pages.PathKey
    , frontmatter : TemplateType
    , body : String
    }
    -> Maybe (Result String Rss.Item)
metadataToRssItem page =
    case page.frontmatter of
        TemplateType.Tip tip ->
            page.body
                |> MarkdownToHtmlStringRenderer.renderMarkdown
                |> Result.map
                    (\markdownHtmlString ->
                        { title = tip.title
                        , description = tip.description
                        , url = PagePath.toString page.path
                        , categories = []
                        , author = "Dillon Kearns"
                        , pubDate = Rss.Date tip.publishedAt
                        , content = Just markdownHtmlString
                        , contentEncoded = Just markdownHtmlString
                        , enclosure = Nothing
                        }
                    )
                |> Just

        _ ->
            Nothing


type alias View =
    List (Element Msg)


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.MinimalUi
    , orientation = Manifest.Portrait
    , description = siteTagline
    , iarcRatingId = Nothing
    , name = "Incremental Elm Consulting"
    , themeColor = Just Color.white
    , startUrl = Pages.pages.index
    , shortName = Just "Incremental Elm"
    , sourceIcon = Pages.images.iconPng
    }


siteTagline =
    "Incremental Elm Consulting"


type alias Model =
    { menuBarAnimation : View.MenuBar.Model
    , menuAnimation : Animation.State
    , dimensions : Dimensions
    , styles : List Animation.State
    , showMenu : Bool
    , isOnAir : TwitchButton.IsOnAir
    , now : Maybe Time.Posix
    }



--init : ( Model, Cmd Msg )


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


updateStyles : Model -> Model
updateStyles model =
    { model
        | styles =
            model.styles
                |> List.indexedMap makeTranslated
    }


type Msg
    = StartAnimation
    | Animate Animation.Msg
    | InitialViewport Dom.Viewport
    | WindowResized Int Int
    | OnPageChange
    | OnAirUpdated (Result Http.Error TwitchButton.IsOnAir)
    | GotCurrentTime Time.Posix


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


interpolation =
    Animation.easing
        { duration = second * 1
        , ease = Ease.inOutCubic
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Animation.subscription Animate
            (model.styles
                ++ View.MenuBar.animationStates model.menuBarAnimation
                ++ [ model.menuAnimation ]
            )
        , Browser.Events.onResize WindowResized

        --, Time.every (oneSecond * 60) GotCurrentTime
        ]


oneSecond : Float
oneSecond =
    1000


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



--view :  List ( PagePath Pages.PathKey, TemplateType Msg ) -> Page (TemplateType Msg) (List (Element Msg)) Pages.PathKey -> { title : String, body : Html Msg }


ensureAtPrefix : String -> String
ensureAtPrefix twitterUsername =
    if twitterUsername |> String.startsWith "@" then
        twitterUsername

    else
        "@" ++ twitterUsername


fullyQualifiedUrl : String -> String
fullyQualifiedUrl url =
    let
        urlWithoutLeadingSlash =
            if url |> String.startsWith "/" then
                url |> String.dropLeft 1

            else
                url
    in
    "https://incrementalelm.com" ++ url


siteName =
    "Incremental Elm Consulting"

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
import Metadata exposing (Metadata)
import Pages
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Platform exposing (Page)
import Pages.StaticHttp as StaticHttp
import Request
import Request.Events exposing (LiveStream)
import Rss
import RssPlugin
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task exposing (Task)
import Time
import TwitchButton
import UpcomingEvent
import View.MenuBar
import View.Navbar
import Widget.Signup


canonicalSiteUrl =
    "https://incrementalelm.com"


main : Pages.Platform.Program Model Msg (Metadata Msg) (List (Element Msg))
main =
    Pages.Platform.init
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents =
            [ { extension = "md"
              , metadata = Metadata.decoder
              , body = MarkdownRenderer.view
              }
            ]
        , manifest = manifest
        , canonicalSiteUrl = canonicalSiteUrl
        , onPageChange = Just (\_ -> OnPageChange)
        , internals = Pages.internals
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
            , siteUrl = canonicalSiteUrl
            , title = "Incremental Elm Tips"
            , builtAt = Pages.builtAt
            , indexPage = Pages.pages.tips
            , now = Pages.builtAt
            }
            metadataToRssItem
        |> Pages.Platform.toProgram


metadataToRssItem :
    { path : PagePath Pages.PathKey
    , frontmatter : Metadata Msg
    , body : String
    }
    -> Maybe Rss.Item
metadataToRssItem page =
    case page.frontmatter of
        Metadata.Tip tip ->
            let
                markdownHtmlString =
                    MarkdownToHtmlStringRenderer.renderMarkdown page.body
                        |> Result.withDefault "TODO"
            in
            Just
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



--view :  List ( PagePath Pages.PathKey, Metadata Msg ) -> Page (Metadata Msg) (List (Element Msg)) Pages.PathKey -> { title : String, body : Html Msg }


eventsView : Maybe Time.Posix -> TwitchButton.IsOnAir -> List LiveStream -> Element msg
eventsView maybeNow isOnAir events =
    let
        upcoming =
            events
                |> List.filter
                    (\event ->
                        case maybeNow of
                            Just now ->
                                Time.posixToMillis event.startsAt > Time.posixToMillis now

                            Nothing ->
                                True
                    )
                |> List.sortBy
                    (\event ->
                        Time.posixToMillis event.startsAt
                    )

        recordings =
            events
                |> List.filter
                    (\event ->
                        case maybeNow of
                            Just now ->
                                Time.posixToMillis event.startsAt <= Time.posixToMillis now

                            Nothing ->
                                False
                    )
                |> List.sortBy
                    (\event ->
                        -(Time.posixToMillis event.startsAt)
                    )
    in
    TwitchButton.viewIfOnAir isOnAir Element.none
        :: ((upcoming |> List.map Request.Events.view)
                ++ (recordings |> List.map Request.Events.recordingView)
           )
        |> Element.column [ Element.spacing 30, Element.centerX ]


view allMetadata page =
    if page.path == Pages.pages.live.index then
        StaticHttp.map
            (\events ->
                { head = head page.frontmatter
                , view =
                    \model viewForPage ->
                        let
                            { title, body } =
                                pageOrPostView allMetadata model page viewForPage
                        in
                        { title = title
                        , body =
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
                                Element.column
                                    --[ Element.width (Element.fill |> Element.maximum 600)
                                    [ Element.width Element.fill
                                    ]
                                    [ body
                                    , eventsView model.now model.isOnAir events
                                    ]
                            )
                                |> Element.layout
                                    [ Element.width Element.fill
                                    ]
                        }
                }
            )
            (Request.staticGraphqlRequest Request.Events.selection)

    else
        StaticHttp.succeed
            { head = head page.frontmatter
            , view =
                \model viewForPage ->
                    let
                        { title, body } =
                            pageOrPostView allMetadata model page viewForPage
                    in
                    { title = title
                    , body =
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
                            body
                        )
                            |> Element.layout
                                [ Element.width Element.fill
                                ]
                    }
            }



--pageOrPostView : List ( PagePath Pages.PathKey, Metadata Msg ) -> Model -> Page (Metadata Msg) (List (Element Msg)) Pages.PathKey -> { title : String, body : Element Msg }


pageOrPostView allMetadata model page viewForPage =
    case page.frontmatter of
        Metadata.Page metadata ->
            { title = metadata.title
            , body =
                [ header model
                , (if page.path == Pages.pages.articles.index then
                    [ Index.view allMetadata ]

                   else if page.path == Pages.pages.learn.index then
                    [ LearnIndex.view allMetadata ]

                   else if page.path == Pages.pages.glossary.index then
                    [ allMetadata
                        |> GlossaryIndex.view
                    ]

                   else
                    viewForPage
                  )
                    |> Element.textColumn
                        [ Element.centerX
                        , Element.width Element.fill
                        , Element.spacing 30
                        , Font.size 18
                        ]
                    |> Element.el
                        [ Element.width Element.fill
                        , Element.height Element.fill
                        , if Dimensions.isMobile model.dimensions then
                            Element.padding 20

                          else
                            Element.paddingXY 200 50
                        , Element.spacing 30
                        ]
                ]
                    |> Element.column [ Element.width Element.fill ]
            }

        Metadata.Article metadata ->
            { title = metadata.title.raw
            , body =
                [ header model
                , ((metadata.title.styled
                        |> Element.paragraph [ Font.size 36, Font.center, Font.family [ Font.typeface "Raleway" ], Font.bold ]
                   )
                    :: (Element.image
                            [ Element.width (Element.fill |> Element.maximum 600)
                            , Element.centerX
                            ]
                            { src = metadata.coverImage
                            , description = metadata.title.raw
                            }
                            |> Element.el [ Element.centerX ]
                       )
                    :: viewForPage
                  )
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
                        , Element.padding 30
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
                , Element.textColumn [ Element.spacing 15, Element.centerX, Element.paddingXY 0 50 ]
                    [ Element.paragraph
                        [ Font.size 36
                        , Font.center
                        , Font.family [ Font.typeface "Raleway" ]
                        , Font.bold
                        ]
                        [ Element.text metadata.title ]
                    , viewForPage
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
                ]
                    |> Element.column [ Element.width Element.fill ]
            }

        Metadata.Glossary metadata ->
            { title = metadata.title
            , body =
                [ header model
                , Element.textColumn [ Element.spacing 15, Element.centerX, Element.paddingXY 0 50 ]
                    [ Element.paragraph
                        [ Font.size 36
                        , Font.center
                        , Font.family [ Font.typeface "Raleway" ]
                        , Font.bold
                        ]
                        [ Element.text metadata.title ]
                    , Element.paragraph [] [ Element.text metadata.description ]
                    , viewForPage
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
                ]
                    |> Element.column [ Element.width Element.fill ]
            }

        Metadata.Tip metadata ->
            { title = metadata.title
            , body =
                [ header model
                , Element.textColumn
                    [ Element.spacing 15
                    , Element.centerX
                    , Element.paddingXY 0 50
                    , Element.width Element.shrink
                    ]
                    [ Element.textColumn
                        [ Element.centerX
                        , Element.spacing 30
                        , Font.size 18
                        , if Dimensions.isMobile model.dimensions then
                            Element.width (Element.fill |> Element.maximum 600)

                          else
                            Element.width (Element.fill |> Element.maximum 700)
                        , Element.padding 20
                        ]
                        (Element.paragraph
                            [ Font.size 36
                            , Font.center
                            , Font.family [ Font.typeface "Raleway" ]
                            , Font.bold
                            ]
                            [ Element.text metadata.title ]
                            :: Element.paragraph
                                [ Element.padding 20 ]
                                [ Element.text metadata.description ]
                            :: viewForPage
                            ++ [ Widget.Signup.view "Get Weekly Tips" "906002494" [] ]
                        )
                    ]
                ]
                    |> Element.column [ Element.width Element.fill ]
            }


{-| <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/abouts-cards>
<https://htmlhead.dev>
<https://html.spec.whatwg.org/multipage/semantics.html#standard-metadata-names>
<https://ogp.me/>
-}
head : Metadata.Metadata msg -> List (Head.Tag Pages.PathKey)
head metadata =
    case metadata of
        Metadata.Page meta ->
            Head.Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = siteName
                , image =
                    { url = Pages.images.icon
                    , alt = meta.title
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = meta.description |> Maybe.withDefault meta.title
                , title = meta.title
                , locale = Nothing
                }
                |> Head.Seo.website

        Metadata.Article meta ->
            Head.Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = siteName
                , image =
                    -- TODO fix image
                    { url = Pages.images.architecture
                    , alt = meta.description.raw
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = meta.description.raw
                , title = meta.title.raw
                , locale = Nothing
                }
                |> Head.Seo.article
                    { tags = []
                    , section = Nothing
                    , publishedTime = Nothing
                    , modifiedTime = Nothing
                    , expirationTime = Nothing
                    }

        Metadata.Learn meta ->
            []

        Metadata.Glossary meta ->
            []

        Metadata.Tip meta ->
            []


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

port module Main exposing (main)

import Animation
import Browser.Dom as Dom
import Browser.Events
import Color
import DateFormat
import Dimensions exposing (Dimensions)
import Ease
import Element exposing (Element)
import Element.Font as Font
import Element.Lazy
import ElmLogo
import Head as Head exposing (Tag)
import Head.Seo
import Html
import Html.Attributes as Attr
import Html.Lazy
import Index
import Json.Decode
import Json.Encode as Encode
import LearnIndex
import MarkdownRenderer
import Metadata exposing (Metadata)
import Pages
import Pages.Document
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.Platform exposing (Page)
import Pages.StaticHttp as StaticHttp
import Request
import Request.Events exposing (LiveStream)
import Request.GoogleCalendar as GoogleCalendar exposing (Event)
import Style
import Style.Helpers as Helpers
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task exposing (Task)
import Time
import View.MenuBar
import View.Navbar


port initialTimeZoneName : (String -> msg) -> Sub msg


main : Pages.Platform.Program Model Msg (Metadata Msg) (List (Element Msg))
main =
    Pages.Platform.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents = [ markupDocument, markdownDocument ]
        , manifest = manifest
        , canonicalSiteUrl = "https://incrementalelm.com"
        , onPageChange = \_ -> OnPageChange
        , internals = Pages.internals
        , generateFiles = \_ -> []
        }


type alias View =
    List (Element Msg)


markupDocument : ( String, Pages.Document.DocumentHandler (Metadata Msg) View )
markupDocument =
    Pages.Document.parser
        { extension = "emu"
        , metadata = Json.Decode.succeed <| Metadata.Page { title = "TODO - convert to md" }
        , body = \_ -> Ok [ Element.text "TODO - convert to markdown." ]
        }


markdownDocument : ( String, Pages.Document.DocumentHandler (Metadata Msg) View )
markdownDocument =
    Pages.Document.parser
        { extension = "md"
        , metadata = Metadata.decoder
        , body = MarkdownRenderer.view
        }


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
    , timezone : NamedZone
    }


namedUtc : NamedZone
namedUtc =
    { name = "UTC"
    , zone = Time.utc
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
      , timezone = namedUtc
      }
        |> updateStyles
    , Cmd.batch
        [ Dom.getViewport
            |> Task.perform InitialViewport
        ]
    )


type alias NamedZone =
    { name : String
    , zone : Time.Zone
    }


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
    | GotTimeZone NamedZone
    | GotTimeZoneName String


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
            ( model, Cmd.none )

        GotTimeZone namedZone ->
            ( { model | timezone = namedZone }, Cmd.none )

        GotTimeZoneName zoneName ->
            let
                task =
                    Time.here
                        |> Task.map
                            (\zone ->
                                { name = zoneName
                                , zone = zone
                                }
                            )
            in
            ( model, task |> Task.perform GotTimeZone )


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
        , initialTimeZoneName GotTimeZoneName
        ]


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


eventsView : NamedZone -> List LiveStream -> Element msg
eventsView timezone events =
    events
        |> List.map (eventView timezone)
        |> Element.column [ Element.spacing 30, Element.centerX ]


eventView : NamedZone -> LiveStream -> Element msg
eventView timezone event =
    Element.column [ Element.spacing 20 ]
        [ Element.newTabLink []
            { url = "" -- event.url
            , label =
                Element.text event.title
                    |> Element.el
                        [ Font.bold
                        , Font.size 24
                        ]
            }
        , Html.node "intl-time" [ Attr.property "editorValue" (event.startsAt |> Time.posixToMillis |> Encode.int) ] []
            |> Element.html
            |> Element.el
                [ Font.size 20
                ]
        , Element.newTabLink []
            { url = GoogleCalendar.googleAddToCalendarLink event
            , label =
                Helpers.button
                    { fontColor = .mainBackground
                    , backgroundColor = .light
                    , size = Style.fontSize.body
                    }
                    [ Element.text "Add to Google Calendar"
                    ]
            }
        ]


view allMetadata page =
    if page.path == Pages.pages.events.index then
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
                                Element.column [ Element.width Element.fill ]
                                    [ body
                                    , eventsView model.timezone events
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
                        [ if Dimensions.isMobile model.dimensions then
                            Element.width (Element.fill |> Element.maximum 600)

                          else
                            Element.width Element.fill
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
                , description = meta.title
                , title = meta.title
                , locale = Nothing
                }
                |> Head.Seo.website

        Metadata.Article meta ->
            let
                twitterUsername =
                    "dillontkearns"

                twitterSiteAccount =
                    "incrementalelm"

                image =
                    fullyQualifiedUrl meta.coverImage
            in
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

module Main exposing (main)

import Animation exposing (backgroundColor)
import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation
import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import ElmLogo
import Html exposing (Html)
import Style exposing (fonts, palette)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Time
import Url exposing (Url)
import Url.Builder


type alias Model =
    { styles : List Animation.State
    , dimensions :
        { width : Float
        , height : Float
        }
    , page : Page
    , key : Browser.Navigation.Key
    }


type Page
    = Home
    | WhyElm


type Msg
    = Animate Animation.Msg
    | InitialViewport Browser.Dom.Viewport
    | WindowResized Int Int
    | UrlChanged Url
    | UrlRequest Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Animate time ->
            ( { model
                | styles = List.map (Animation.update time) model.styles
              }
            , Cmd.none
            )

        InitialViewport { viewport } ->
            let
                _ =
                    Debug.log "viewport" viewport
            in
            ( { model
                | dimensions =
                    { width = viewport.width
                    , height = viewport.height
                    }
              }
            , Cmd.none
            )

        WindowResized width height ->
            ( { model
                | dimensions =
                    { width = toFloat width
                    , height = toFloat height
                    }
              }
            , Cmd.none
            )

        UrlChanged url ->
            let
                newPage =
                    case url.fragment of
                        Nothing ->
                            -- If we got a link that didn't include a fragment,
                            -- it's from one of those (href "") attributes that
                            -- we have to include to make the RealWorld CSS work.
                            --
                            -- In an application doing path routing instead of
                            -- fragment-based routing, this entire
                            -- `case url.fragment of` expression this comment
                            -- is inside would be unnecessary.
                            Home

                        Just fragment ->
                            case fragment of
                                "why-elm" ->
                                    WhyElm

                                _ ->
                                    Home
            in
            ( { model | page = newPage }, Cmd.none )

        UrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    -- ( model
                    -- , Nav.load href
                    -- )
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
    case page of
        Home ->
            { title = "Incremental Elm"
            , body = [ mainView model ]
            }

        WhyElm ->
            { title = "Incremental Elm - Why Elm?"
            , body = [ mainView model ]
            }


wrappedText contents =
    Element.paragraph [] [ Element.text contents ]


bulletPoint content =
    "→ "
        ++ content
        |> wrappedText
        |> Element.el
            [ fonts.body
            , Element.Font.size 25
            ]


mainView ({ page } as model) =
    case page of
        WhyElm ->
            Element.column
                [ Element.height Element.shrink
                , Element.alignTop
                , Element.width Element.fill
                ]
                [ navbar model
                , Element.text "Why Elm Contents..."
                ]
                |> Element.layout []

        Home ->
            Element.column
                [ Element.height Element.shrink
                , Element.alignTop
                , Element.width Element.fill
                ]
                [ navbar model
                , whyElmSection
                , whyIncrementalSection
                ]
                |> Element.layout []


whyElmSection =
    bulletSection
        { backgroundColor = palette.highlightBackground
        , fontColor = Element.rgb 255 255 255
        , headingText = "Want a highly reliable & maintainable frontend?"
        , bulletContents =
            [ "Zero runtime exceptions"
            , "Rely on language guarantees instead of discipline"
            , "Predictable code - no globals or hidden side-effects"
            ]
        , append =
            Element.link
                [ Element.centerX
                ]
                { url = "/#why-elm"
                , label =
                    "Read About Why Elm?"
                        |> wrappedText
                        |> Element.el
                            [ Element.Border.rounded 10
                            , Background.color palette.light
                            , Element.Font.color white
                            , Element.padding 15
                            , Element.Font.size 18
                            , Element.pointer
                            , Element.mouseOver
                                [ Background.color (elementRgb 25 151 192)
                                ]
                            ]
                }
        }


elementRgb red green blue =
    Element.rgb (red / 255) (green / 255) (blue / 255)


white =
    elementRgb 255 255 255


bulletSection { backgroundColor, fontColor, headingText, bulletContents, append } =
    Element.column
        [ Background.color backgroundColor
        , Element.height (Element.shrink |> Element.minimum 300)
        , Element.width Element.fill
        ]
        [ Element.column
            [ Element.Font.color fontColor
            , Element.centerY
            , Element.width Element.fill
            , Element.Font.size 55
            , fonts.body
            , Element.spacing 25
            , Element.padding 30
            ]
            (List.concat
                [ [ headingText
                        |> wrappedText
                        |> Element.el
                            [ fonts.title
                            , Element.centerX
                            , Element.Font.center
                            ]
                  ]
                , List.map bulletPoint bulletContents
                , [ append ]
                ]
            )
        ]


whyIncrementalSection =
    bulletSection
        { backgroundColor = palette.mainBackground
        , fontColor = palette.bold
        , headingText = "How do I start?"
        , bulletContents =
            [ "One tiny step at a time!"
            , "See how Elm fits in your environment: learn the fundamentals and ship something in less than a week!"
            , "Elm is all about reliability. Incremental Elm Consulting gets you there reliably"
            ]
        , append = Element.none
        }


logoText =
    [ Element.text "Incremental Elm"
        |> Element.el
            [ Element.Font.color palette.bold
            , Element.Font.size 50
            ]
    , Element.text "Consulting"
        |> Element.el
            [ Element.Font.color palette.bold
            , Element.Font.size 17
            , Element.alignRight
            ]
    ]
        |> Element.column
            [ fonts.title
            , Element.width Element.shrink
            , Element.height Element.shrink
            , Element.spacing 5
            ]


isMobile { dimensions } =
    dimensions.width < 1000


navbar model =
    if isMobile model then
        Element.column
            [ Background.color palette.mainBackground
            , Element.alignTop
            , Element.centerX
            , Element.padding 25
            ]
            [ animationView model
            , logoText
            ]

    else
        Element.link []
            { label =
                Element.row
                    [ Background.color palette.mainBackground
                    , Element.alignTop
                    ]
                    [ animationView model
                    , logoText
                    ]
            , url = "/"
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
            , if isMobile model then
                Element.width Element.fill

              else
                Element.width (Element.px 100)
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
      , dimensions =
            { width = 0
            , height = 0
            }
      , page =
            if url.fragment == Just "why-elm" then
                WhyElm

            else
                Home
      , key = navigationKey
      }
        |> updateStyles
    , Browser.Dom.getViewport
        |> Task.perform InitialViewport
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Animation.subscription Animate model.styles
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

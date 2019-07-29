port module Main exposing (main)

import Animation
import Browser
import Browser.Dom as Dom
import Browser.Events
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Dimensions exposing (Dimensions)
import Ease
import Element exposing (Element)
import Element.Border
import Element.Font as Font
import ElmLogo
import Html exposing (Html)
import Html.Attributes
import Json.Decode
import Json.Encode
import List.Extra
import Mark
import Mark.Error
import MarkParser
import Metadata exposing (Metadata)
import Pages
import Pages.Content as Content exposing (Content)
import Pages.HeadTag as HeadTag exposing (HeadTag)
import Pages.Parser exposing (PageOrPost)
import RawContent
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Time
import Url exposing (Url)
import Url.Builder
import View.MenuBar
import View.Navbar


port toJsPort : Json.Encode.Value -> Cmd msg


type alias Flags =
    {}


main : Pages.Program Flags Model Msg (Metadata Msg) (Element Msg)
main =
    Pages.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , parser = MarkParser.document
        , content = RawContent.content
        , toJsPort = toJsPort
        , headTags = headTags
        , siteUrl = "https://incrementalelm.com"
        }


type alias Model =
    { menuBarAnimation : View.MenuBar.Model
    , menuAnimation : Animation.State
    , dimensions : Dimensions
    , styles : List Animation.State
    , showMenu : Bool
    }


init : Pages.Flags Flags -> ( Model, Cmd Msg )
init flags =
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
      }
    , Dom.getViewport
        |> Task.perform InitialViewport
    )


type Msg
    = StartAnimation
      -- | Animate Animation.Msg
    | InitialViewport Dom.Viewport
    | WindowResized Int Int


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



-- Animate time ->
--     ( { model
--         | styles = List.map (Animation.update time) model.styles
--         , menuBarAnimation = View.MenuBar.update time model.menuBarAnimation
--         , menuAnimation = Animation.update time model.menuAnimation
--       }
--     , Cmd.none
--     )


interpolation =
    Animation.easing
        { duration = second * 1
        , ease = Ease.inOutCubic
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    -- Sub.batch
    --     [ Animation.subscription Animate
    --         (model.styles
    --             ++ View.MenuBar.animationStates model.menuBarAnimation
    --             ++ [ model.menuAnimation ]
    --         )
    -- ,
    Browser.Events.onResize WindowResized


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


view : Model -> PageOrPost (Metadata Msg) (Element Msg) -> { title : String, body : Html Msg }
view model pageOrPost =
    let
        { title, body } =
            pageOrPostView model pageOrPost
    in
    { title = title
    , body =
        body
            |> Element.layout
                [ Element.width Element.fill
                ]
    }


pageOrPostView : Model -> PageOrPost (Metadata Msg) (Element Msg) -> { title : String, body : Element Msg }
pageOrPostView model pageOrPost =
    case pageOrPost.metadata of
        Metadata.Page metadata ->
            { title = metadata.title
            , body =
                [ header model
                , pageOrPost.view
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
                    |> Element.column [ Element.width Element.fill ]
            }

        Metadata.Article metadata ->
            { title = metadata.title.raw
            , body =
                [ header model
                , (metadata.title.styled
                    :: (Element.image
                            [ Element.width (Element.fill |> Element.maximum 600)
                            , Element.centerX
                            ]
                            { src = metadata.coverImage
                            , description = metadata.title.raw
                            }
                            |> Element.el [ Element.centerX ]
                       )
                    :: pageOrPost.view
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
                        , Element.padding 20
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
                , pageOrPost.view
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
                    |> Element.column [ Element.width Element.fill ]
            }


{-| <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/abouts-cards>
<https://htmlhead.dev>
<https://html.spec.whatwg.org/multipage/semantics.html#standard-metadata-names>
<https://ogp.me/>
-}
headTags : String -> Metadata.Metadata msg -> List HeadTag
headTags canonicalUrl metadata =
    let
        siteName =
            "Incremental Elm Consulting"

        themeColor =
            "#ffffff"
    in
    [ HeadTag.node "meta" [ ( "name", "theme-color" ), ( "content", themeColor ) ]
    , HeadTag.node "meta"
        [ ( "property", "og:site_name" )
        , ( "content", siteName )
        ]
    , HeadTag.node "meta"
        [ ( "property", "og:url" )
        , ( "content", canonicalUrl )
        ]
    , HeadTag.node "link"
        [ ( "rel", "canonical" )
        , ( "href", canonicalUrl )
        ]
    ]
        ++ pageTags metadata


ensureAtPrefix : String -> String
ensureAtPrefix twitterUsername =
    if twitterUsername |> String.startsWith "@" then
        twitterUsername

    else
        "@" ++ twitterUsername


pageTags metadata =
    case metadata of
        Metadata.Page record ->
            []

        Metadata.Article meta ->
            let
                description =
                    meta.title.raw

                title =
                    meta.title.raw

                twitterUsername =
                    "dillontkearns"

                twitterSiteAccount =
                    "incrementalelm"

                image =
                    meta.coverImage
            in
            [ HeadTag.node "meta"
                [ ( "property", "og:title" )
                , ( "content", title )
                ]
            , HeadTag.node "meta"
                [ ( "name", "description" )
                , ( "content", description )
                ]
            , HeadTag.node "meta"
                [ ( "property", "og:description" )
                , ( "content", description )
                ]
            , HeadTag.node "meta"
                [ ( "property", "og:image" )
                , ( "content", image )
                ]
            , HeadTag.node "meta"
                [ ( "name", "image" )
                , ( "content", image )
                ]
            , HeadTag.node "meta"
                [ ( "property", "og:type" )
                , ( "content", "article" )
                ]
            , HeadTag.node "meta"
                [ ( "name", "twitter:card" )
                , ( "content", "summary_large_image" )
                ]
            , HeadTag.node "meta"
                [ ( "name", "twitter:creator" )
                , ( "content", ensureAtPrefix twitterUsername )
                ]
            , HeadTag.node "meta"
                [ ( "name", "twitter:site" )
                , ( "content", ensureAtPrefix twitterSiteAccount )
                ]
            , HeadTag.node "meta"
                [ ( "name", "twitter:description" )
                , ( "content", meta.title.raw )
                ]
            , HeadTag.node "meta"
                [ ( "name", "twitter:image" )
                , ( "content", image )
                ]
            , HeadTag.node "meta"
                [ ( "name", "twitter:image:alt" )
                , ( "content", description )
                ]
            ]

        Metadata.Learn meta ->
            let
                description =
                    meta.title

                title =
                    meta.title

                twitterUsername =
                    "dillontkearns"

                twitterSiteAccount =
                    "incrementalelm"

                image =
                    Nothing
            in
            [ HeadTag.node
                "meta"
                [ ( "property", "og:title" )
                , ( "content", title )
                ]
                |> Just
            , HeadTag.node
                "meta"
                [ ( "name", "description" )
                , ( "content", description )
                ]
                |> Just
            , HeadTag.node
                "meta"
                [ ( "property", "og:description" )
                , ( "content", description )
                ]
                |> Just
            , image
                |> Maybe.map
                    (\i ->
                        HeadTag.node
                            "meta"
                            [ ( "property", "og:image" )
                            , ( "content", i )
                            ]
                    )
            , image
                |> Maybe.map
                    (\i ->
                        HeadTag.node
                            "meta"
                            [ ( "name", "image" )
                            , ( "content", i )
                            ]
                    )
            , HeadTag.node
                "meta"
                [ ( "property", "og:type" )
                , ( "content", "article" )
                ]
                |> Just
            , HeadTag.node
                "meta"
                [ ( "name", "twitter:card" )
                , ( "content", "summary_large_image" )
                ]
                |> Just
            , HeadTag.node
                "meta"
                [ ( "name", "twitter:creator" )
                , ( "content", ensureAtPrefix twitterUsername )
                ]
                |> Just
            , HeadTag.node
                "meta"
                [ ( "name", "twitter:site" )
                , ( "content", ensureAtPrefix twitterSiteAccount )
                ]
                |> Just
            , HeadTag.node
                "meta"
                [ ( "name", "twitter:description" )
                , ( "content", description )
                ]
                |> Just
            , image
                |> Maybe.map
                    (\i ->
                        HeadTag.node
                            "meta"
                            [ ( "name", "twitter:image" )
                            , ( "content", i )
                            ]
                    )
            , HeadTag.node
                "meta"
                [ ( "name", "twitter:image:alt" )
                , ( "content", description )
                ]
                |> Just
            ]
                |> List.filterMap identity

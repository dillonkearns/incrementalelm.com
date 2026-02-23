module Route.Courses exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import Cloudinary
import CourseIcon
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html
import Html.Attributes as Attr
import Link
import PagesMsg exposing (PagesMsg)
import Pages.Url
import Route
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import Tailwind as Tw exposing (classes)
import Tailwind.Theme exposing (background, s2, s4, s6)
import View exposing (Body(..), View, freeze)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


type alias Data =
    ()


data : BackendTask FatalError Data
data =
    BackendTask.succeed ()


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url =
                Cloudinary.url "v1614626600/Incremental_Elm_Logo_aeb8qs.png"
                    Nothing
                    400
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Master tools and techniques to become a better Elm developer."
        , locale = Nothing
        , title = "Incremental Elm Courses"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app sharedModel =
    { title = "Incremental Elm Courses"
    , body =
        Tailwind
            [ (Route.Courses__Course___Section_
                { course = "elm-ts-interop"
                , section = "intro"
                }
                |> Link.htmlLink2
                    [ classes
                        [ Tw.border_2
                        , Tw.raw "border-foreground"
                        , Tw.raw "rounded-lg"
                        , Tw.flex
                        , Tw.flex_col
                        , Tw.items_center
                        , Tw.raw "gap-4"
                        , Tw.p s6
                        ]
                    ]
                    [ Html.div
                        []
                        [ CourseIcon.elmTsInterop ]
                    , Html.div []
                        [ Html.h2
                            [ classes
                                [ Tw.raw "font-bold"
                                , Tw.raw "text-xl"
                                ]
                            ]
                            [ Html.text "Intro to elm-ts-interop"
                            ]
                        ]
                    , Html.p []
                        [ Html.text "Intro to the basics of using elm-ts-interop to generate TypeScript bindings for type-safe ports and flags."
                        ]
                    , Html.a
                        [ classes
                            [ Tw.raw "hover:bg-foreground-strong"
                            , Tw.raw "hover:underline"
                            , Tw.px s4
                            , Tw.py s2
                            , Tw.raw "bg-foreground"
                            , Tw.text_simple background
                            , Tw.raw "rounded-lg"
                            , Tw.text_center
                            , Tw.cursor_pointer
                            ]
                        , Attr.href "/courses/elm-ts-interop/intro"
                        ]
                        [ Html.text "Watch Now"
                        ]
                    ]
              )
                |> freeze
            ]
    }

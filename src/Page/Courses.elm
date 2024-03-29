module Page.Courses exposing (Data, Model, Msg, page)

import Cloudinary
import CourseIcon
import Css
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled as Html
import Html.Styled.Attributes as Attr exposing (css)
import Link
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Route
import Shared
import Tailwind.Utilities as Tw
import View exposing (Body(..), View)


type alias Model =
    {}


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type alias Data =
    ()


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
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
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Incremental Elm Courses"
    , body =
        Tailwind
            [ Route.Courses__Course___Section_
                { course = "elm-ts-interop"
                , section = "intro"
                }
                |> Link.htmlLink2
                    [ css
                        [ Tw.border_2
                        , Tw.border_foreground
                        , Tw.rounded_lg
                        , Tw.flex
                        , Tw.flex_col
                        , Tw.items_center
                        , Tw.gap_4
                        , Tw.p_6
                        ]
                    ]
                    [ Html.div
                        [ css
                            []
                        ]
                        [ CourseIcon.elmTsInterop ]
                    , Html.div []
                        [ Html.h2
                            [ css
                                [ Tw.font_bold
                                , Tw.text_xl
                                ]
                            ]
                            [ Html.text "Intro to elm-ts-interop"
                            ]
                        ]
                    , Html.p []
                        [ Html.text "Intro to the basics of using elm-ts-interop to generate TypeScript bindings for type-safe ports and flags."
                        ]
                    , Html.a
                        [ css
                            [ Css.hover
                                [ Tw.bg_foregroundStrong
                                , Tw.underline
                                ]
                            , Tw.px_4
                            , Tw.py_2
                            , Tw.bg_foreground
                            , Tw.text_background
                            , Tw.rounded_lg
                            , Tw.text_center
                            , Tw.cursor_pointer
                            ]
                        , Attr.href "/courses/elm-ts-interop/intro"
                        ]
                        [ Html.text "Watch Now"
                        ]
                    ]
            ]
    }

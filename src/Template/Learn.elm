module Template.Learn exposing (..)

import Element
import Element.Font as Font
import Head
import Head.Seo
import Pages
import Pages.PagePath exposing (PagePath)
import Shared
import Site
import Template exposing (StaticPayload)
import TemplateType exposing (TemplateType)


type alias Model =
    ()


type alias Msg =
    Never


template : Template.Template_ TemplateType.LearnMetadata ()
template =
    Template.noStaticData
        { head =
            \_ -> []
        }
        |> Template.buildNoState { view = view }


view :
    List ( PagePath Pages.PathKey, TemplateType )
    -> Template.StaticPayload TemplateType.LearnMetadata templateStaticData
    -> Shared.RenderedBody
    -> Shared.PageView Never
view allMetadata static viewForPage =
    { title = static.metadata.title
    , body =
        [ Element.paragraph
            [ Font.size 36
            , Font.center
            , Font.family [ Font.typeface "Raleway" ]
            , Font.bold
            ]
            [ Element.text static.metadata.title ]
        , viewForPage
            |> Element.textColumn
                [ Element.centerX
                , Element.width Element.fill
                , Element.spacing 30
                , Font.size 18
                ]
        ]
    }


head :
    StaticPayload TemplateType.TipMetadata ()
    -> List (Head.Tag Pages.PathKey)
head { metadata, path } =
    Head.Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = Site.name
        , image =
            { url = Pages.images.articleCover.lofotenHike
            , alt = metadata.description
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = metadata.description
        , title = metadata.title
        , locale = Nothing
        }
        |> Head.Seo.article
            { tags = []
            , section = Nothing
            , publishedTime = Nothing
            , modifiedTime = Nothing
            , expirationTime = Nothing
            }

module Template.Page exposing (..)

import Element
import GlossaryIndex
import Head
import Head.Seo
import Index
import LearnIndex
import Pages
import Pages.PagePath
import Shared
import Site
import Template exposing (StaticPayload)
import TemplateType exposing (TemplateType)


type alias Model =
    ()


type alias Msg =
    Never


template : Template.Template TemplateType.PageMetadata ()
template =
    Template.noStaticData { head = head }
        |> Template.buildNoState { view = view }


view :
    List ( Pages.PagePath.PagePath Pages.PathKey, TemplateType.TemplateType )
    -> Template.StaticPayload TemplateType.PageMetadata templateStaticData
    -> Shared.RenderedBody
    -> Shared.PageView Never
view allMetadata static viewForPage =
    { title = static.metadata.title
    , body =
        if static.path == Pages.pages.articles.index then
            [ Index.view allMetadata ]

        else if static.path == Pages.pages.learn.index then
            [ LearnIndex.view allMetadata ]

        else if static.path == Pages.pages.glossary.index then
            [ allMetadata
                |> GlossaryIndex.view
            ]

        else
            viewForPage
    }


head :
    StaticPayload TemplateType.PageMetadata ()
    -> List (Head.Tag Pages.PathKey)
head { metadata } =
    Head.Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = Site.name
        , image =
            { url = metadata.image |> Maybe.withDefault Pages.images.icon
            , alt = metadata.title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = metadata.description |> Maybe.withDefault metadata.title
        , title = metadata.title
        , locale = Nothing
        }
        |> Head.Seo.website

module Template.Page exposing (..)

import Element
import GlossaryIndex
import Index
import LearnIndex
import Pages
import Pages.PagePath
import Shared
import Template
import TemplateType


type alias Model =
    ()


type alias Msg =
    Never


template : Template.Template_ templateMetadata ()
template =
    Template.noStaticData
        { head =
            \_ -> []
        }
        |> Template.buildNoState
            { view = view }


view :
    List ( Pages.PagePath.PagePath Pages.PathKey, TemplateType.TemplateType )
    -> Template.StaticPayload templateMetadata templateStaticData
    -> Shared.RenderedBody
    -> Shared.PageView Never
view allMetadata static viewForPage =
    { title = ""
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

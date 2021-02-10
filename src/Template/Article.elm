module Template.Article exposing (..)

import Element
import Element.Font as Font
import Head
import Head.Seo
import Pages
import Pages.ImagePath as ImagePath
import Pages.PagePath exposing (PagePath)
import Shared
import Site
import Template exposing (StaticPayload)
import TemplateType


type alias Model =
    ()


type alias Msg =
    Never


template : Template.Template TemplateType.ArticleMetadata ()
template =
    Template.noStaticData { head = head }
        |> Template.buildNoState { view = view }


view :
    List ( PagePath Pages.PathKey, TemplateType.TemplateType )
    -> Template.StaticPayload TemplateType.ArticleMetadata ()
    -> Shared.RenderedBody
    -> Shared.PageView Never
view allMetadata static viewForPage =
    { title = static.metadata.title
    , body =
        (static.metadata.title
            |> Element.text
            |> List.singleton
            |> Element.paragraph [ Font.size 36, Font.center, Font.family [ Font.typeface "Raleway" ], Font.bold ]
        )
            :: (Element.image
                    [ Element.width (Element.fill |> Element.maximum 600)
                    , Element.centerX
                    ]
                    { src = ImagePath.toString static.metadata.coverImage
                    , description = static.metadata.title
                    }
                    |> Element.el [ Element.centerX ]
               )
            :: viewForPage
    }


head :
    StaticPayload TemplateType.ArticleMetadata ()
    -> List (Head.Tag Pages.PathKey)
head { metadata, path } =
    Head.Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = Site.name
        , image =
            { url = metadata.coverImage
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

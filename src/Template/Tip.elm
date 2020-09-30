module Template.Tip exposing (..)

import Element
import Element.Font as Font
import Pages
import Pages.PagePath
import Palette
import Shared
import Template
import TemplateType
import Widget.Signup


type alias Model =
    ()


type alias Msg =
    Never


template : Template.Template_ TemplateType.TipMetadata ()
template =
    Template.noStaticData
        { head =
            \_ -> []
        }
        |> Template.buildNoState { view = view }


view :
    List ( Pages.PagePath.PagePath Pages.PathKey, TemplateType.TemplateType )
    -> Template.StaticPayload TemplateType.TipMetadata templateStaticData
    -> Shared.RenderedBody
    -> Shared.PageView Never
view allMetadata static viewForPage =
    { title = static.metadata.title
    , body =
        [ [ Element.paragraph
                [ Font.size 36
                , Font.center
                , Font.family [ Font.typeface "Raleway" ]
                , Font.bold
                ]
                [ Element.text static.metadata.title ]
          ]
        , [ Element.paragraph [ Element.padding 20 ] [ Palette.textQuote static.metadata.description ] ]
        , viewForPage
        , [ Widget.Signup.view "Get Weekly Tips" "906002494" [] ]
        ]
            |> List.concat
    }

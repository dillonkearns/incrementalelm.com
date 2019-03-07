module Page.Events exposing (view)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Style exposing (fontSize, fonts, palette)
import Style.Helpers
import View.FontAwesome
import View.SignupForm


events : List Event
events =
    [ { tag = GraphQL
      , name = "Advanced Elm GraphQL Workshop"
      , url = "https://www.eventbrite.com/e/advanced-elm-graphql-techniques-workshop-tickets-56480425473"
      }
    ]


type Tag
    = GraphQL


type alias Event =
    { tag : Tag
    , name : String
    , url : String
    }


view : Dimensions -> Element.Element msg
view dimensions =
    Element.column
        [ Style.fontSize.medium
        , Element.width Element.fill
        , Element.height Element.fill
        , Element.padding
            (if Dimensions.isMobile dimensions then
                20

             else
                50
            )
        , Element.spacing 30
        , Element.width (Element.fill |> Element.maximum 900)
        , Element.centerX
        ]
        [ eventsView
        ]


eventsView : Element msg
eventsView =
    Element.column [] (events |> List.map eventView)


eventView : Event -> Element msg
eventView event =
    Style.Helpers.link { url = event.url, content = event.name }

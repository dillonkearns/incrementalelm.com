module Page.Learn.GettingStarted exposing (details)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Font
import Page.Learn.Post exposing (Post)
import Style
import View.Ellie
import View.Resource as Resource exposing (Resource)


details : Post msg
details =
    { pageName = "getting-started"
    , title = "Getting Started Resources"
    , body = body
    , resources =
        { title = Nothing
        , items =
            [ { name = "The Official Elm Guide"
              , url = "https://guide.elm-lang.org/"
              , kind = Resource.Article
              , description = Just "Learn the fundamentals from Evan Czaplicki, the creator of Elm. It's pretty concise, I recommend going through it when you first start with Elm!"
              }
            , { name = "Making Impossible States Impossible"
              , url = "https://www.youtube.com/watch?v=IcgmSRJHu_8"
              , kind = Resource.Video
              , description = Just "Once Elm beginners have learned the basic Elm syntax, the next stumbling block I see is often learning to write idiomatic Elm code. Idiomatic Elm code uses Custom Types, which are much more expressive than the types most languages have (if they are typed at all). This 20-minute video teaches you how to use types to eliminate corner-cases at compile-time!"
              }
            , { name = "Elm in Action"
              , url = "https://www.manning.com/books/elm-in-action"
              , kind = Resource.Book
              , description = Just "If you want to thoroughly master the fundamentals, I highly recommend working through this book!"
              }
            , { name = "The Elm Slack"
              , url = "https://elmlang.herokuapp.com"
              , kind = Resource.App
              , description = Just "This is a great place to get help when you're starting out, there are lots of friendly people in #beginners."
              }
            ]
        }
    }


body dimensions =
    [ [ Element.text "Here are my favorite resources for learning the Elm fundamentals." ]
        |> Element.paragraph [ Element.Font.center, Element.width Element.fill ]
    ]

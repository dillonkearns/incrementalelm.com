module Page.Learn.Post exposing (Post, all)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import View.Resource as Resource exposing (Resource)


type alias Post =
    { pageName : String
    , title : String
    , body : String
    , resources : Maybe { title : Maybe String, items : List Resource }
    }


all : List Post
all =
    [ { pageName = "getting-started"
      , title = "Getting Started Resources"
      , body = """Here are my favorite resources for learning the Elm fundamentals.

| Resource
    title = The Official Elm Guide
    url = https://guide.elm-lang.org/
    icon = Article

Learn the fundamentals from Evan Czaplicki, the creator of Elm. It's pretty concise, I recommend going through it when you first start with Elm!

| Resource
    title = Making Impossible States Impossible
    url = https://www.youtube.com/watch?v=IcgmSRJHu_8
    icon = Video

Once Elm beginners have learned the basic Elm syntax, the next stumbling block I see is often learning to write idiomatic Elm code. Idiomatic Elm code uses Custom Types, which are much more expressive than the types most languages have (if they are typed at all). This 20-minute video teaches you how to use types to eliminate corner-cases at compile-time!

| Resource
    title = Elm in Action
    url = https://www.manning.com/books/elm-in-action
    icon = Book

If you want to thoroughly master the fundamentals, I highly recommend working through this book!

| Resource
    title = The Elm Slack
    url = https://elmlang.herokuapp.com
    icon = App

This is a great place to get help when you're starting out, there are lots of friendly people in #beginners."""
      , resources = Nothing
      }
    , { pageName = "editor-config"
      , title = "Recommended Editor Configuration"
      , body =
            """Right now, our editor of choice is Atom because of the excellent Elm tools available in that editor.


I'm closely watching the rapid and promising improvements in {Link|the Intellij Elm plugin | url = https://github.com/klazuka/intellij-elm }. At the moment it's missing some very useful features that Atom has support for, so it gets second place for me. Also, the Vim support is decent in Intellij, and outstanding in Atom, which is a big plus for me!

To see some of the great features of Atom's Elm integration in action, look at the {Link|docs from the Elmjutsu Atom package| url = https://atom.io/packages/elmjutsu}.

| Header
    Recommended Atom Configuration

First, download and install the {Link|Atom editor| url = https://atom.io/}.

You can install our recommended core Elm packages in one go by running this from your terminal after installing Atom:


| Monospace
    apm install elmjutsu elm-lens elm-format atom-ide-ui language-elm

| List
    - {Link|Elmjutsu| url = https://atom.io/packages/elmjutsu} - see link for a full list of functionality.
    - {Link|elm-lens | url = https://atom.io/packages/elm-lens } - annotates unused functions with warnings. Tells you if you have exposed functions with no external usage as well.
    - {Link|Atom IDE UI | url = https://atom.io/packages/atom-ide-ui } - provides a UI for displaying in-editor compiler errors & command-click to navigate to definition functionality.
    - {Link|elm-format package | url = https://atom.io/packages/elm-format } - Runs {Code|elm-format} on save in your editor. Requires that you've run {Code|npm install -g elm-format}.

| Header
    Atom Vim Configuration

If you like Vim, Atom has the best Vim support of any editor I've used! It even has first-class integration with Atom's built-in multiple cursors feature. Here is our recommended setup:

| Monospace
    apm install vim-mode-plus vim-mode-plus-keymaps-for-surround

See the docs for lots of details about the features in vim-mode-plus.

| List
    - {Link|vim-mode-plus | url = https://atom.io/packages/vim-mode-plus }
    - {Link|vim-mode-plus surround keybindings | url = https://atom.io/packages/vim-mode-plus-keymaps-for-surround }

"""
      , resources = Nothing
      }
    , { pageName = "architecture"
      , title = "The Elm Architecture"
      , body =
            """| Image
    src = /assets/architecture.jpg
    description = The Elm Architecture


| Ellie
    3xfc59cYsd6a1

| Header
    Further Reading and Exercises

| Resources
    | Resource
        title = Architecture section of The Official Elm Guide
        url = https://guide.elm-lang.org/architecture/
        icon = Article
    | Resource
        title = Add a -1 button to the Ellie example
        url = https://ellie-app.com/3xfc59cYsd6a1
        icon = Exercise"""
      , resources = Nothing
      }
    ]

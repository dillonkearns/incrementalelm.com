{- Copied from https://github.com/matheus23/elm-markdown-transforms/blob/02fddd3bf9e82412eb289bead3b5124a98163ab6/src/Markdown/Scaffolded.elm
   Modified to use BackendTask instead of StaticHttp
-}


module Markdown.Scaffolded exposing
    ( Block(..)
    , toRenderer
    )

{-|


# Rendering Markdown with Scaffolds, Reducers and Folds

(This is called recursion-schemes in other languages, but don't worry, you don't have to
write recursive functions (this is the point of all of this ;) )!)

This is module provides a more **complicated**, but also **more powerful and
composable** way of rendering markdown than the built-in elm-markdown
[`Renderer`](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/Markdown-Renderer).

If you feel a little overwhelmed with this module at first, I recommend taking a look at
the [What are reducers?](#what-are-reducers-) section.


# Main Datastructure

@docs Block


# Transformation Building Blocks

@docs reduceHtmlWords, reduce


### What are 'reducers'?

In this context of the library, we're often working with functions of the type
`Block view -> view`, where `view` might be something like `Html Msg` or `String`, etc.
or, generally, functions of structure `Block a -> b`.

I refer to functions of that structure as 'reducers'. (This is somewhat different to the
'real' terminology, but I feel like they capture the nature of 'reducing once' very well.)

If you know `List.foldr` you already know an example for a reducer (the first argument)!
The reducers in this module are no different, we just write them in different ways.

We can do the same thing we did for this library for lists:

    type ListScaffold elem a
        = Empty
        | Cons elem a

    reduceEmpty = 0

    reduceCons a b = a + b

    handler listElement =
        case listElement of
            Empty ->
                reduceEmpty

            Cons elem accumulated ->
                reduceCons elem accumulated

    foldl : (ListScaffold a b -> b) -> List a -> b
    foldl handle list =
        case list of
            [] -> handle Empty
            (x:xs) -> handle (Cons x xs)

    foldl handler == List.foldl reduceCons reduceEmpty

The last line illustrates how different ways of writing these reducers relate: For
`List.foldl` we simply provide the cases (empty or cons) as different arguments,
for reducers in this library, we create a custom type case for empty and cons.


### What are 'folds'?

Some functions have similar, but not quite the type that a reducers has. For example:

  - `Block (Request a) -> Request (Block a)`
  - `Block (Maybe a) -> Maybe (Block a)`
  - `Block (Result err a) -> Result err (Block a)`
  - `Block (environment -> a) -> environment -> Block a`

All of these examples have the structure `Block (F a) -> F (Block a)` for some `F`. You
might have to squint your eyes at the last two of these examples. Especially the last one.
Let me rewrite it with a type alias:

    type alias Function a b =
        a -> b

    foldFunction : Block (Function env a) -> Function env (Block a)


### Combining Reducers

You can combine multiple 'reducers' into one. There's no function for doing this, but a
pattern you might want to follow.

Let's say you want to accumulate both all the words in your markdown and the `Html` you
want it to render to, then you can do this:

    type alias Rendered =
        { html : Html Msg
        , words : List String
        }

    reduceRendered : Block Rendered -> Rendered
    reduceRendered block =
        { html = block |> map .html |> reduceHtml
        , words = block |> map .words |> reduceWords
        }

If you want to render to more things, just add another parameter to the record type and
follow the pattern. It is even possible to let the rendered html to depend on the words
inside itself (or maybe something else you're additionally reducing to).


# Conversions

Did you already start to write a custom elm-markdown `Renderer`, but want to use this
library? Don't worry. They're compatible. You can convert between them!

@docs toRenderer


# Utilities

I mean to aggregate utilites for transforming Blocks in this section.

-}

import Markdown.Block as Block
import Markdown.Html
import Markdown.Renderer exposing (Renderer)



-- EXPOSED DEFINITIONS


{-| A datatype that enumerates all possible ways markdown could wrap some children.

Kind of like a 'Scaffold' around something that's already built, which will get torn down
after building is finished.

This does not include Html tags.

If you look at the left hand sides of all of the functions in the elm-markdown
[`Renderer`](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/Markdown-Renderer),
you'll notice a similarity to this custom type, except it's missing a type for 'html'.

Defining this data structure has some advantages in composing multiple Renderers.

It has a type parameter `children`, which is supposed to be filled with `String`,
`Html msg` or similar. Take a look at some [reducers](#transformation-building-blocks) for examples of this.

There are some neat tricks you can do with this data structure, for example, `Block Never`
represents only non-nested blocks of markdown.

-}
type Block children
    = Heading { level : Block.HeadingLevel, rawText : String, children : List children }
    | Paragraph (List children)
    | BlockQuote (List children)
    | Text String
    | CodeSpan String
    | Strong (List children)
    | Emphasis (List children)
    | Link { title : Maybe String, destination : String, children : List children }
    | Image { alt : String, src : String, title : Maybe String }
    | UnorderedList { items : List (Block.ListItem children) }
    | OrderedList { startingIndex : Int, items : List (List children) }
    | CodeBlock { body : String, language : Maybe String }
    | HardLineBreak
    | ThematicBreak
    | Table (List children)
    | TableHeader (List children)
    | TableBody (List children)
    | TableRow (List children)
    | TableCell (Maybe Block.Alignment) (List children)
    | TableHeaderCell (Maybe Block.Alignment) (List children)


{-| Convert a function that works with `Block` to a `Renderer` for use with
elm-markdown.

(The second parameter is a [`Markdown.Html.Renderer`](/packages/dillonkearns/elm-markdown/3.0.0/Markdown-Html#Renderer))

-}
toRenderer :
    { renderMarkdown : Block view -> view
    , renderHtml : Markdown.Html.Renderer (List view -> view)
    }
    -> Renderer view
toRenderer { renderMarkdown, renderHtml } =
    { heading = Heading >> renderMarkdown
    , paragraph = Paragraph >> renderMarkdown
    , blockQuote = BlockQuote >> renderMarkdown
    , html = renderHtml
    , text = Text >> renderMarkdown
    , codeSpan = CodeSpan >> renderMarkdown
    , strong = Strong >> renderMarkdown
    , emphasis = Emphasis >> renderMarkdown
    , strikethrough = Emphasis >> renderMarkdown
    , hardLineBreak = HardLineBreak |> renderMarkdown
    , link =
        \{ title, destination } children ->
            Link { title = title, destination = destination, children = children }
                |> renderMarkdown
    , image = Image >> renderMarkdown
    , unorderedList =
        \items ->
            UnorderedList { items = items }
                |> renderMarkdown
    , orderedList =
        \startingIndex items ->
            OrderedList { startingIndex = startingIndex, items = items }
                |> renderMarkdown
    , codeBlock = CodeBlock >> renderMarkdown
    , thematicBreak = ThematicBreak |> renderMarkdown
    , table = Table >> renderMarkdown
    , tableHeader = TableHeader >> renderMarkdown
    , tableBody = TableBody >> renderMarkdown
    , tableRow = TableRow >> renderMarkdown
    , tableHeaderCell = \maybeAlignment -> TableHeaderCell maybeAlignment >> renderMarkdown
    , tableCell = \maybeAlignment -> TableCell maybeAlignment >> renderMarkdown
    }


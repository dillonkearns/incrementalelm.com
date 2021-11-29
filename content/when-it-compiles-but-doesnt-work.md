---
publishAt: "2021-11-29"
cover: 1587629329288-949a7cbefb89
---

# When It Compiles, But Doesn't Work

In Elm code, "if it compiles, it works." Does that come for free? Let's see if we can find Elm code where "it compiles, but it doesn't work" to see what we can learn about writing maintainable Elm code.

## Violins and Vuvuzelas

Do violins make beautiful sounds? As a non-violinist who has tried a violin, I'm living proof that sometimes the sounds they create are not so beautiful. But there's plenty of proof that they make beautiful sounds as well.

Does a vuvuzela make beautiful sounds? I don't think it's controversial to say that it's probably not even possible. So violins are something special without a doubt. While a violin can't make beautiful sounds without the right technique, it is equipped with several tools that give it unique expressive power. By changing the angle of the bow, how close to the bridge you play, the speed of the bow, and by moving our fingers on the fingerboard (vibrato, intonation), there is as much expressive power as almost any musical instrument in the violin.

## The Expressive Power of a Vuvuzela

Elm doesn't give you safe code for free. It does help you avoid several footguns through its explicit semantics and strict type system. But just as importantly, it provides tools for you to express the constraints of your system. And when you express those constraints in Elm, you can really trust them. There is no way to bypass the constraints or fool the type system. So having the expressive power of a vuvuzela will limit you. But tools are only as good as our ability to make use of them. Elm's guarantees are 100% not 99%. But it can't enforce constraints that are specific to your domain. So remember that it's up to you to write custom tailored guarantees for your domain. As an Elm developer, you're like the violinst - you have a beautiful tool in your hands but its up to you to use it to its full potential.

To make the most of these tools for enforcing constraints, lets see what happens when we don't make use of them. Lets try to pinpoint the key techniques for leveraging those tools to make Elm code feel like "if it compiles, it works."

## Defaults, Squelched Errors, and Catch-Alls

```elm
username
    -- this should never happen
    |> Maybe.withDefault ""
```

I'm guilty of writing code like this. And if you're like me, you know the feeling of spending too much time debugging a problem only to find a line of code like this and realizing that you should always expect the unexpected.

This can be particularly elusive when these default values trickle their way through the system to end up in states that otherwise seemed impossible. It can also lead to silent runtime failures instead of a descriptive compiler error (inexhaustive case errors, type errors, etc.).

That can mean the difference between Elm being a helpful and alert assistant and Elm becoming a lazy assistant. Elm can only help you enforce the constraints you tell it about.

Also be on the lookout for catch-all clauses like this in your code:

```elm
type Membership
    = Pro
    | Free

case membership of
    Pro ->
      "Pro"

    _ ->
        "Free"
```

This will fall through to the correct value now, but if you add a new `Membership` level then you'll end up with code that "compiles, but doesn't work."

```diff
type Membership
    = Pro
+   | Premium
    | Free
```

Note that catch-all's can be what you want in some cases, so you need to use your judgement to make sure it's what you want. For example, perhaps an `isFree : Membership -> Bool` could safely use a catch-all. Though the cost of handling it explicitly is low, and there's always a risk that the catch-all could cause you to miss something important (like adding a `FreeTrial` level of `Membership`).

As an alternative to default values, squelched errors, and catch-alls, you can consider using `Debug.todo` statements as a placeholder for unhandled cases during development. Then you are reminded to handle those cases before your code goes live (since `elm --optimize` will fail if there are any uses of `Debug`).

## Types _With_ Borders

If you've ever iterated on writing an `elm/json` `Decoder` then you know that you can easily write JSON Decoders (or encode JSON values) where it "compiles, but doesn't work." That's because within the local scope of your Elm application everything is consistent, and you've handled the possible errors in your Decoding or HTTP requests.

Using [[types-without-borders]] can help avoid this case of "compiles, but doesn't work," by keeping your types in sync across the boundaries of your frontend. Some helpful tools for that include:

- Lamdera
- `elm-graphql`
- Custom code generation
- `elm-ts-interop`
- [`elm-protocol-buffers`](https://github.com/eriktim/elm-protocol-buffers)

## Making Impossible States _Possible_

This topic comes up a lot in the Elm world, so by now we have plenty of great resources that show how these Impossible States can cause our code to "compile, but not work."

So be sure to [[make-impossible-states-impossible]]. Reduce states to valid states as much as possible. Keep in mind that it's not just about valid combinations of state.
Make the smallest amount of state possible to express (and no less). A useful technique is to count [the cardinatlity of your types](https://guide.elm-lang.org/appendix/types_as_sets.html). You can construct a table of values you can express with your types to help identify invalid ones.

## Primitive Obsession

The code smell often referred to as [Primitive Obsession](https://wiki.c2.com/?PrimitiveObsession) is when values like String or Int are over-used. Under the hood, you'll need Strings and Ints, but you can give better semantics and enforce more constraints if you create new Custom Types to wrap those primitives. For example, instead of a `String` we could use `type Username = Username String` and instead of an `Int` we could use `type UserId = UserId Int`.

Here's some code that "compiles, but doesn't work" because it allows an `Int` instead of a more constrained Custom Type:

```elm
getUserProfileInfo :
    (Result Http.Error User -> msg)
    -> Int
    -> Cmd msg

update msg model =
    -- ...
    ( model,
      getUserProfileInfo
        GotUserProfile
        product.id
    )
```

If we use a Custom Type, we could turn this into "it doesn't compile, so it doesn't work":

```elm
getUserProfileInfo :
    (Result Http.Error User -> msg)
    -> UserId
    -> Cmd msg

update msg model =
    -- ...
    ( model,
      getUserProfileInfo
        GotUserProfile
        product.id -- compiler error
        -- need to use model.currentUser.id to fix it
    )
```

Don't forget to [[wrap-early-unwrap-late]] - the goal is to have the best representation of our data for the entire life of the value.

## Opaque Types

A `UserId` like the example above only helps us if we use an Opaque Type to help us enforce the constraint. If we can use `UserId product.id` then there's not much improvement.

An Opaque Type helps you reduce the surface area where you need to think about a constraint ([[opaque-types-let-you-think-locally]]). That means you can trust that a `UserId` is what it says it is.

Use Opaque Types to help enforce constraints about:

- Where the data came from
- How the data can be used
- How the data has been validated (especially helpful with the concept of [[parse-dont-validate]])

For example, if a username must be non-empty, representing usernames as `String`s or as a Custom Type that can be freely created outside of a Username module (non-opaque types) means you need to be careful about that constraint everywhere in your codebase.

By hiding the constructor from outside of the `Username` module, you can enforce that guarantee in one place and have confidence in that guarantee everywhere outside of that module.

```elm
module Username exposing (Username, fromString)

type Username = Username String

fromString : String -> Maybe Username
fromString rawUsername =
    if isValid rawUsername then
        rawUsername |> Username |> Just
    else
        Nothing

isValid : String -> Bool
```

If you need to be careful about upholding constraints on a huge surface area in your codebase, then you won't be able to make changes with confidence. If you have a small surface area with clear responsibilities enforced within opaque types, then you can be confident the constraints will still be enforced when you change code outside the Opaque Type's module.

## Getting to "If It Compiles, It Works"

We're still human, and we can still introduce bugs. And these techniques work best in tandem with automated tests, not instead of tests. But if you keep these techniques in mind, you'll get the feeling of making bulletproof changes to code that comes from using the tools Elm gives us to their full potential.

[//begin]: # "Autogenerated link references for markdown compatibility"
[types-without-borders]: types-without-borders "Types Without Borders"
[make-impossible-states-impossible]: make-impossible-states-impossible "Make Impossible States Impossible"
[wrap-early-unwrap-late]: wrap-early-unwrap-late "Wrap Early, Unwrap Late"
[opaque-types-let-you-think-locally]: opaque-types-let-you-think-locally "Opaque Types Let You Think Locally"
[parse-dont-validate]: parse-dont-validate "Parse, Don't Validate"
[//end]: # "Autogenerated link references"

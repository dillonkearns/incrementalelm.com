# Violins and Vuvuzelas

In Elm code, "if it compiles, it works." Does that apply to all Elm code? Let's see if we can find Elm code where "it compiles, but it doesn't work" to better understand quality in Elm code.

## The Expressive Power of a Vuvuzela

Do violins make beautiful sounds? As a non-violinist who has tried a violin, I'm living proof that they can make the opposite of beautiful sounds. But there's plenty of proof that they make incredibly beautiful sounds as well.

Does a vuvuzela make beautiful sounds? I don't think it's controversial to say that it's probably not even possible. So violins are something special without a doubt. While a violin can't make beautiful sounds without the right technique, it is equipped with several tools that give it unique expressive power. By changing the angle of the bow, how close to the bridge you play, the speed of the bow, and by moving our fingers on the fingerboard (vibrato, intonation), there is as much expressive power as almost any musical instrument in the violin.

Similarly, Elm doesn't give you safe code for free. It does help you avoid several footguns through its explicit semantics and strict type system. But just as importantly, it provides tools for you to express the constraints of your system. And when you express those constraints in Elm, you can really trust them. There is no way to bypass the constraints or fool the type system. That means the guarantees you get are 100% not 99%. To me, the difference between a 100% guarantee and a 99% guarantee is a lot like the difference between a violin and a vuvuzela.

So remember that it's up to you to write custom tailored guarantees for your domain. As an Elm developer, you're like the violinst - you have a beautiful tool in your hands but its up to you to use it to its full potential.

To make the most of these tools for enforcing constraints, lets see what happens when we don't make use of them. Lets try to pinpoint the key techniques for leveraging those tools to make Elm code feel like "if it compiles, it works."

## Defaults, Squelched Errors, and Catch-Alls

```elm
username
    -- this should never happen
    |> Maybe.withDefault ""
```

I'm guilty of writing code like this. And if you're like me, you know the feeling of spending too much time debugging a problem only to find a line of code like this and think "oh yes, of course!"

This can be particularly elusive when these default values trickle their way through the system to end up in states that otherwise seemed impossible. It can also lead to silent runtime failures instead of a descriptive compiler error (inexhaustive case errors, type errors, etc.).

It can be the difference between Elm being a helpful and alert assistant and Elm becoming an incompotent and lazy assistant. Elm can only help you enforce the constraints you tell it about.

---

TODO: too many Maybe's, Result's, etc. can lead to this problem, too.

Catch-all clauses in case expressions and squelched errors are shortcuts that can easily allow strange states in our applications.

As an alternative, consider using `Debug.todo` statements as a placeholder for unhandled cases during development so that you are reminded to handle those cases before your code goes live (since `elm --optimize` will fail if there are any uses of `Debug`).

## Unclear Semantics

Wrapping to late, or unwrapping too early, having function parameters that are too permissive, or having Strings or values that don't represent their constraints (UniqueUsername, VerifiedEmail, etc.).

## Elm's Tools for Constraints

- [[types-without-borders]]
- [[parse-dont-validate]]
- `elm-review`

## Narrow Types

[[make-impossible-states-impossible]]. Reduce states to valid states as much as possible. Keep in mind that it's not just about valid combinations of state.
Make the smallest amount of state possible to express (and no less). Don't forget to pay attention to [the Cardinatlity of your types](https://guide.elm-lang.org/appendix/types_as_sets.html).

```elm
type alias TrafficLightState = {
       color : String
   }
```

```elm
type TrafficLightColor = Red | Green | Yellow
type alias TrafficLightState = {
       color : TrafficLightColor
   }
```

## Avoid squelching errors

Even with Elm's approach of explicit errors and errors as data (not control flow), it's possible to ignore error states with default values.

```elm
username |> validateUsername |> Result.withDefault
```

```elm
update msg model =
  case msg of
        GotCurrentUser userResult ->
            ( { model | user = userResult |> Result.toMaybe }, Cmd.none )
        -- ...
```

## Opaque Types

An [[opaque-type]] can help you reduce the surface area where you need to think about a constraint. If a username must be non-empty, representing usernames as a `String` means you need to be careful about that constraint throughout your codebase. In other words, it's easy to make a change but find that "it compiles, but it doesn't work!" Using `type Username = Username String` is no better than a plain `String`, _unless_ the `Username` type is Opaque. That is, unless you expose the `Username` type (left-hand side) but not its constructor (right-hand side).

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

If you need to be careful about upholding constraints on a huge surface area in your codebase, then you won't be able to make changes with confidence. If you have a small surface area with clear responsibilities enforced within opaque types, then you're one step closer to "if it compiles, it works."

[//begin]: # "Autogenerated link references for markdown compatibility"
[types-without-borders]: types-without-borders "Types Without Borders"
[parse-dont-validate]: parse-dont-validate "Parse, Don't Validate"
[make-impossible-states-impossible]: make-impossible-states-impossible "Make Impossible States Impossible"
[opaque-type]: opaque-type "Opaque Type"
[//end]: # "Autogenerated link references"

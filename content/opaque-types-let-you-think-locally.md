---
publishAt: "2021-10-25"
cover: 1458301661715-1ab7b95a395c
---

# Opaque Types Let You Think Locally

Elm's Opaque Types are a powerful tool for narrowing the surface area where you check a constraint. TypeScript's Branded Types give similar functionality but without closing outside use, so you can't be sure the constraints are enforced everywhere. Let's explore the differences to better understand why Elm's Opaque Types are such an important tool.

Strictly speaking, opaque types don't make Elm's type system more sound. Instead, they help you narrow your thinking of how a particular type is used to within a single module. They allow you to check that a constraint is enforced in a single module, rather than having to ensure that a constraint is enforced throughout your entire codebase, both now and in the future.

For example, if you want to ensure that a String actually represents a confirmed email address, that has nothing to do with type soundness - the type is just a String. But if the only way to get a value with `type ConfirmedEmailAddress = ConfirmedEmailAddress String` is through an HTTP request to a specific server endpoint, then you can trust any value of that type after checking the `ConfirmedEmailAddress` module and the API endpoint. You just need to make sure that you trust that server endpoint and the `ConfirmedEmailAddress` module. It's the same idea as [[exit-gatekeepers]].

```elm
module ConfirmedEmailAddress exposing (ConfirmedEmailAddress, checkEmailAddress)

type ConfirmedEmailAddress = ConfirmedEmailAddress String

checkEmailAddress : (Result Http.Error ConfirmedEmailAddress -> msg) -> String -> Cmd msg
checkEmailAddress toMsg emailAddress =
  Http.post
    { url = "https://example.com/confirm-email-address.json?email="
          ++ Url.percentEncode emailAddress
    , body = Http.emptyBody
    , expect = Http.expectJson toMsg
        (Json.Decode.string
            |> Json.Decode.map ConfirmedEmailAddress
        )
    }
```

Compare this with Branded Types in [[typescript]].

```typescript
type ConfirmedEmailAddress = string & { __brand: "ConfirmedEmailAddress" };

// uh oh, any code can brand it
const unconfirmedEmail = "unconfirmed-email@example.com" as (string & {
  __brand: "ConfirmedEmailAddress");
};
```

So some drawbacks to Branded Types in TypeScript are:

- They are open and can be branded by code anywhere in the codebase
- They use casting to intersect two contradictory types. This allows you to create an artificial type that can only be created through "branding", but it feels like a little bit of a hack. It also illustrates that the branding occurs through casting which allows you to tell the TypeScript compiler what the type of a value is, but [this can be error prone because you could tell it incorrect type information](/typescript-blind-spots#casts)

## Checking Currency

Another example of a Branded Type in TypeScript is marking a type as representing a specific currency.

```typescript
type Usd = number & { __brand: "USD" };

function fromCents(cents: number): Usd {
  return cents as Usd;
}
```

This `Usd` type allows us to brand a number so we know it represents US Dollars. That's great because we want to:

1. Ensure that the currency is not mistakenly combined with a different currency
2. Ensure that we use a consistent representation (for example, if the number represents cents as an integer rather than dollars as a float)

For point 2, we want to make sure that there is a single place that builds up currency. For example, we don't want someone to accidentally use dollars as a float somewhere. But since a Branded Type in TypeScript is "open" and uses casting to create it, there is no single place that we can enforce as the only place the logic for creating and dealing with that type. So any outside code can brand it like this:

```typescript
// whoops, (fromCents(150) === 150), (fromCents(150) !== 1.5)
const aDollarFifty = 1.5 as number & { __brand: "USD" };
```

Compare that with an Opaque Type in Elm.

```elm
module Money exposing (Money, Usd)

type Money currency = Money Int

type Usd = Usd

fromUsDollars : Int -> Money Usd
fromUsDollars dollarAmount = Usd (dollarAmount * 100)

fromUsCents : Int -> Money Usd
fromUsCents usCents = Usd usCents
```

Our Elm `Usd` type cannot be created outside of that module. If we want to see how that type is being used, we only have one place to look: within the `Money` module where it's defined. Since it isn't exposed to the outside world, we know that we've limited the possible ways that outside code can use that type.

## Branded Types and Unique Symbols

The technique described above is the idiomatic approach to branded types in TypeScript ([used in the official TypeScript examples](https://www.typescriptlang.org/play#example/nominal-typing) and [in the TypeScript codebase](https://github.com/Microsoft/TypeScript/blob/7b48a182c05ea4dea81bab73ecbbe9e013a79e99/src/compiler/types.ts#L693-L698)). There is another technique that allows you to provide unique brands that are enclosed within a given scope using Unique Symbols.

```typescript
module Email {
  declare const confirmedEmail_: unique symbol;

  type ConfirmedEmail = string & {[confirmedEmail_]: true};

  export function fromServer(emailAddress: string): ConfirmedEmail {
    // validate email address
    return emailAddress as ConfirmedEmail;
  }
}

const unconfirmedEmail = "unconfirmed-email@example.com" as // ??? there's no exported type to use here
```

This technique succeeds in ensuring that the `ConfirmedEmail` type cannot be constructed outside of the scope of `Email` (assuming you don't use `any` types of course).

However, now we have no exported type to use to annotate values to ensure that the correct type is used. That means we can't write code like this outside of the scope of `Email`:

```typescript
function sendEmail(email: Email.ConfirmedEmail) {
  // ...
}
```

You could certainly implement `sendEmail` within the scope of `Email`. But I think being able to annotate values is an important feature that is likely to become a roadblock when we want to ensure we receive our unique branded type as a parameter somewhere outside of `Email`.

We could `export` the `ConfirmedEmail` type to outside of the `Email` module, but then that gets us back at the initial challenge with branded types: the type can be used to cast a value that is constructed anywhere in our codebase.

```typescript
const unconfirmedEmail =
  "unconfirmed-email@example.com" as Email.ConfirmedEmail;
```

The TypeScript language have a specific feature for opaque types (like [Flow's Opaque Type Aliases](https://flow.org/en/docs/types/opaque-types/)), but it [seems that they plan to stick with the current branded types approach as the recommended solution](https://github.com/microsoft/TypeScript/issues/15807).

## More Resources

Opaque Types in Elm are a powerful tool to let you narrow the scope of code you need to think about to make sure you've gotten your constraints right.

- Check out our [Opaque Types Elm Radio episode](https://elm-radio.com/episode/intro-to-opaque-types).
- We also have an Elm Radio episode where we do a thorough [comparison of Elm and TypeScript's Type Systems](https://elm-radio.com/episode/ts-and-elm-type-systems)
- Joël Quenneville's talk [A Number by Any Other Name](https://www.youtube.com/watch?v=WnTw0z7rD3E) has some great examples as well.
- [[typescript-blind-spots]] catalogs all the ways that you can introduce unsound types in a TypeScript program

[//begin]: # "Autogenerated link references for markdown compatibility"
[exit-gatekeepers]: exit-gatekeepers "Using elm types to prevent logging social security #'s"
[typescript]: typescript "TypeScript"
[typescript-blind-spots]: typescript-blind-spots "TypeScript's Blind Spots"
[//end]: # "Autogenerated link references"

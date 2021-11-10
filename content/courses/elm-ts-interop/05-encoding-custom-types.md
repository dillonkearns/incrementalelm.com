---
title: Encoding Custom Types
description: We use TypeScript Literal Types to encode an Elm Custom Type, and see how elm-ts-interop keeps the two types decoupled.
---

- [`elm-review-ports` rule for `NoUnusedPorts`](https://package.elm-lang.org/packages/sparksp/elm-review-ports/latest/NoUnusedPorts)
- Elm's dead code elimination can cause an error if you don't register ports. `elm-ts-interop` helps avoid this by using a single port-pair (interopToElm and interopFromElm).

## TypeScript Literal types

[TypeScript Literal Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#literal-types) are useful for describing the shape of JSON. Since JSON doesn't have custom types or enums, literals greatly expand the expressive power of JSON.

Since Elm ports and flags are limited to JSON, `elm-ts-interop` relies heavily on the guarantees from TypeScript Literal Types.

An example of a Literal Type is a literal string. With this `elm-ts-json` Encoder:

```elm
encoder : Encoder Kind
encoder =
    TsEncode.literal (Json.Encode.string "hello!")
```

We get a TypeScript type `"hello!"`. Notice that it is a _type_, not just a value.

## Union encoders

<aside title="TypeScript Union Types">

Encodes into a TypeScript Union type. In TypeScript, Union types are "untagged unions". Elm's Custom Types are "tagged unions."

That means we can do

```elm
type IdStringOrNumber = IdString String | IdNumber Int

id : IdStringOrNumber
id = IdString "abc123"
```

```typescript
type Id = string | number;

id: Id = "abc123";
```

</aside>

Similar pattern to [`miniBill/elm-codec`](https://package.elm-lang.org/packages/miniBill/elm-codec/latest/), the first argument is a function which has 1 argument for each variant encoder and 1 argument which is the value that we can do a case expression on.

In the case expression, we pick an encoder to use. The variant encoder parameters correspond to the pipeline below.

```elm
encoder : Encoder Kind
encoder =
    TsEncode.union
        (\vError vWarning vInfo vAlert value ->
            case value of
                Error ->
                    vError

                Warning ->
                    vWarning

                Info ->
                    vInfo

                Alert ->
                    vAlert
        )
        |> TsEncode.variantLiteral (Json.Encode.string "error")
        |> TsEncode.variantLiteral (Json.Encode.string "warn")
        |> TsEncode.variantLiteral (Json.Encode.string "info")
        |> TsEncode.variantLiteral (Json.Encode.string "alert")
        |> TsEncode.buildUnion
```

## Type Narrowing

The TypeScript compiler uses control flow analysis to narrow types. So if you check the type of a value in a conditional, the TypeScript compiler is aware of the type information within the conditional branches.

```typescript
// logKind's type is 'error' | 'warning' | 'info' | 'alert'
if (fromElm.data.logKind === "alert") {
  // logKind's type is 'alert'
} else {
  // logKind's type is 'error' | 'warning' | 'info'
}
```

TypeScript's [Discriminated Union](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types) functionality uses Type Narrowing to get functionality like Elm's case expressions for Custom Types.

## Source of Truth

Serialization for an Encoder, Deserialization for a Decoder. Allows us to decouple type information. The types don't have to match in Elm and TypeScript. But we can safely change our Encoders and Decoders because the type information will always be in sync with `elm-ts-interop`.

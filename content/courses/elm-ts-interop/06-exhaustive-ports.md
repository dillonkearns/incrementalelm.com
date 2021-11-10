---
mediaId: xAr00W4RJ3yIBoyzquSUU014ZR1ASuArMpsO21taCv00bo
title: Exhaustive Ports
description: We see how elm-ts-interop lets us do exhaustive checks for our ports just like an Elm update case expression.
---

- We add a variant to our InteropDefinitions.FromElm type

## Wiring in a new `FromElm` variant

Add a variant to our `FromElm`

We now have an inexhaustive case expression in our `fromElm` `Encoder`.

To handle the additional variant in our `Encoder`, the steps are:

- Add a parameter, we can call it `vAttemptLogIn` (`v` is short for _variant_). This parameter will be an encoder that we can use in our case expression.
- Use `vAttemptLogIn` for the `AttemptLogIn record ->` clause in our case expression
- Add another `|> TsEncode.variantTagged` to the pipeline (this is the `Encoder` we get as the `vAttemptLogIn` parameter).

All the code together looks like:

```elm
fromElm : Encoder FromElm
fromElm =
    TsEncode.union
        (\vAlert vAttemptLogIn value ->
            case value of
                Alert string ->
                    vAlert string

                AttemptLogIn record ->
                    vAttemptLogIn record
        )
        |> TsEncode.variantTagged "alert"
            (TsEncode.object
                [ required "message" (\value -> value.message) TsEncode.string
                , required "logKind" (\value -> value.kind) Log.encoder
                ]
            )
        |> TsEncode.variantTagged "attemptLogIn"
            (TsEncode.object
                [ required "username" (\value -> value.username) TsEncode.string
                ]
            )
        |> TsEncode.buildUnion
```

## Handle the new variant in TypeScript

The `fromElm` value we receive in `interopFromElm.subscribe` is a TypeScript Discriminated Union.

## Set up ESLint to catch inexhaustive switch statements

- ESLint rule for exhaustive switch statements [`switch-exhaustiveness-check`](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/switch-exhaustiveness-check.md).
- You can follow the [example `eslint` configuration in the `elm-ts-interop-starter` repo](https://github.com/dillonkearns/elm-ts-interop-starter/blob/main/.eslintrc.js)
- Be sure to run your eslint rules and the TypeScript compiler (`tsc`) on your build server. We don't want our code to go to production if there are any problems here, that way we get more Elm-like guarantees in our TypeScript code like inexhaustive checks.

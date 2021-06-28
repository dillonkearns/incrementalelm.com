---
type: tip
description: It's hard to know when to trust TypeScript for Elm developers who are used to a sound type system. It helps to know where its blind spots are.
publishAt: "2021-02-09"
cover: 1511028931355-082bb4781053
---

# TypeScript's Blind Spots

It would be quite dangerous to drive a car with blind spots, but not know exactly where those blind spots are. You still need to be extra careful, even with a full awareness of the blind spots. But at least you know where to put that extra care.

I look at using TypeScript in much the same way. Knowing its blind spots helps me know when to trust it and when to quadruple check. If you can drive a car without blind spots, then by all means go for the safest option. But if you are in a car with blind spots, learn its blind spots to reduce the risk. As Elm developers, we stay in Elm as much as we can. But we do need to reach out to JS/TS to leverage built-in web APIs, use the NPM ecosystem, etc. So for those times we need it, it's best to understand the blind spots.

In this post, I'll catalog the areas where TypeScript allows incorrect types to pass through.

## The `any` type

The biggest culprit for type blind spots in TypeScript is the `any` type.

The `any` type is similar to Elm's `Debug.todo ""`, which has type `a` (a type variable that could refer to anything). But there are some key differences:

- `Debug.todo` statements can't be used in production optimized code (`elm make --optimize`)
- `Debug.todo` can't be published in Elm packages
- Even if you managed to use `Debug.todo`, your code stops there!

This is a huge distinction. With Elm, even if you manage to "fool" the type system with a `Debug.todo` (or a hack like infinitely recursing to get any type), your code will not proceed with faulty assumptions. It's impossible to write Elm code that will continue on with incorrect types.

As an Elm developer, using TypeScript can feel like shaky ground because of this escape hatch. It's good to understand common sources of `any` types to know where to look out for this kind of blind spot.

### Implicit `any`

By default, TypeScript will use an `any` to describe types that it can't infer, like function parameters without annotations.

```typescript
function inspect(argument) {
  argument("Careful! `argument` is implicitly `any`");
}
```

Using the `noImplicitAny` option in your `tsconfig.json` prevents this problem by giving an error in these situations and requires you to add an annotation. I recommend using the `strict` option in your `tsconfig.json`, which includes the `noImplicitAny` option.

### Explicit `any`

Even with the `noImplicitAny` option, TypeScript will allow you to use _explicit_ `any` types. One useful technique here is to use the `unknown` type as a substitute for `any`. You can think of `unknown` as a type-safe alternative to `any`. `unknown` doesn't create a blind spot in the type system that allows anything to flow through. Rather, it is much like a `Json.Decode.Value` in Elm. You can't use it until you check its types.

```typescript
function prettyPrint(value: unknown): string | null {
  if (value === null) {
    return "<null>";
  } else if (value === undefined) {
    return "<undefined>";
  } else if (typeof value === "string") {
    return value;
  } else if (value && typeof value === "object") {
    return "Object with keys: " + Object.keys(value).join(", ");
  } else {
    return null;
  }
}
```

You can pass any value in to `prettyPrint`, just like you would be able to if the argument was annotated as `any`. But you must check the value before using it because it is `unknown`.

You can use [`@typescript-eslint/no-explicit-any`](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-explicit-any.md) to prevent explicit `any` types in your own code. You can even configure it to auto-fix `any` types in your code and change them to `unknown`.

### `any` in core JavaScript APIs

Some of the core JavaScript APIs have built-in `any` types. `Json.parse` is a common source of `any`'s leaking into your code:

```typescript
JSON.parse(text: string): any
```

```typescript
const definitelyNotAFunction = JSON.parse(
  `"Parsing JSON can never return a function, right?"`
);
definitelyNotAFunction();
// TypeError: definitelyNotAFunction is not a function
```

Yikes! Not only can you assume the parsed JSON is any valid JSON value, but you can even treat it as something besides JSON! Even worse, this can escape into the depths of your code and result in type errors that are far away from their point of origin. In a nutshell, `any` makes it hard to trust _any_ of your code.

You can improve the safety of JSON parsing with tools that are similar to `elm/json` decoding.

- [`io-ts`](https://github.com/gcanti/io-ts/blob/master/index.md)
- [`ajv`](https://ajv.js.org/)
- [`runtypes`](https://github.com/pelotom/runtypes)

There are many different approaches to safer JSON parsing in TypeScript, and it's worth looking at different options and seeing if one is a good fit for your use case and has an API that suites your tastes.

Be on the lookout for `any` types in core JS APIs. Any time you're dealing with dynamic runtime data you're likely to see this. The `eval` function is a classic case of a function that truly does have `any` type. That's a reminder of why `any` is baked into TypeScript: JavaScript is inherently dynamic and dynamically typed.

## `any` types coming from NPM packages or type definitions

Also be aware that TypeScript's declaration functionality allows you to declare the types of existing JavaScript code. These type declarations (usually bundled with an NPM package, or installed with `npm install --save-dev @types/<package-name>`) often use `any` types. And even without using `any`, they could be incorrect because they are declaring types, not _proving_ them soundly through typed code, as we are forced to do in Elm code and Elm packages.

## Imports

Another place to be extra careful is the wiring of imports. When you do an `import` in Elm, you know that it has resolved if your code compiles. With TypeScript, you can describe how to resolve modules using the [`paths` configuration](https://www.typescriptlang.org/tsconfig#paths) in your `tsconfig.json`. This can be convenient or necessary at times, but it's another instance where the TypeScript compiler trusts you to do things correctly and guarantee correctness.

The same is true for defining the [`lib` option](https://www.typescriptlang.org/tsconfig#lib) to describe the types/runtime that you have available (for example, `dom` APIs, `es2020`, `node`). TypeScript takes your word for setting this up correctly, but this could lead to incorrect type checking if you have `lib`s declared that won't be there in your runtime.

The type systems in Elm and TypeScript are operating in fundamentally different ways, built to serve their intended use cases.

Elm is a sandbox where nothing can enter with assumptions about its types. You have to prove everything to the Elm type system.

TypeScript is built in a way that's meant to be good at gradual typing, allowing you to add type information to existing JavaScript code in an incremental way.

## Runtime exceptions

Any TypeScript code can throw an exception without the types indicating they might fail.

There's no way to tell by the types, which feels very different than Elm's errors as data. In particular, be on the lookout for functions around file IO and network requests.

## Mutation by reference

If two references point to the same object reference, you can mutate the references according to their respective types, but they both modify the shared reference. This can lead to incorrect runtime types.

```typescript
let numbers = [1, 2, 3];
let mixedValues: (number | string)[] = numbers;
mixedValues.push("Uh oh, this is not a number");

numbers.map((number) => number * 2);
// [2, 4, 6, NaN]
```

## Index access

TypeScript assumes that the index you access is there.

```typescript
const thisWillBeNull = [1, 2, 3][100];
thisWillBeNull * 2; // NaN
```

The type of `thisWillBeNull` is `number` (it is not nullable).

## Inexhaustive switch statements

By default, TypeScript doesn't require you to exhaustively handle all cases in `switch` statements.

This can be improved with [`typescript-eslint` `switch-exhaustiveness-check`](https://github.com/typescript-eslint/typescript-eslint/blob/9e0f6ddef7cd29f355f398c90f1986e51c4854f7/packages/eslint-plugin/docs/rules/switch-exhaustiveness-check.md).

## Non-null assertions

TypeScript's non-null assertion syntax (`!`) is another place where TypeScript trusts you rather than proving correctness. You can disallow this in your own code with [`@typescript-eslint/no-non-null-assertion`](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-non-null-assertion.md)

## Casts

Casts, also known as TypeAssertions, are another place where the TypeScript compiler will trust you and not check types. See [Assertion Considered Harmul](https://basarat.gitbook.io/typescript/type-system/type-assertion#assertion-considered-harmful)

## Type Coercion

There are several places where JavaScript will coerce types. This is often used as a feature, but it is bug-prone and warrants extra care.

- Falsy values used in conditionals (see [this handy table of truthy and falsy values](https://basarat.gitbook.io/typescript/recap/truthy))
- String concatenation

Gary Bernhardt's famous [Wat video](https://www.destroyallsoftware.com/talks/wat) shows some amusing examples of unexpected type coercion. The type system doesn't stop most of these, so they're worth extra attention.

## Can you trust an unsound type system?

Any chipping away at confidence means that you have to have a skeptical eye at every turn.

Let's think of it in reverse, though. Unit tests don't give us 100% certainty that our code is correct. Even Elm types don't give us 100% certainty that our types our correct. There are plenty of cases where we don't express every single constraint in the type system, and there's a point where it becomes so verbose to constrain your types that its more pragmatic to stop short of perfect types. Jeroen and I discuss this in our [Make Impossible States Impossible Elm Radio episode](https://elm-radio.com/episode/impossible-states).

Yes, TypeScript's type system is far less robust than Elm's. But it's far _more_ robust than the type-safety you get in vanilla JavaScript! And I'll take all the added safety I can get! So any time I find myself reaching for JavaScript, I try to take advantage of TypeScript's added safety.

As much as I like to strive for soundness, correctness, and certainty, I will take any tool that can boost my confidence. None of these tools guarantee correctness at every level. But if you know what guarantees they offer, you can understand what suite of tools to use to give you as much confidence as possible.

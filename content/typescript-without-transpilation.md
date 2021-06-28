---
type: tip
description: Using TypeScript for your JavaScript has a lot of benefits. For Elm devs, the transpilation step is a burden. But you can get all the benefits and skip the transpilation.
publishAt: "2021-02-01"
---

# TypeScript Without Transpilation

The first rule of Elm is that you want to write _everything_ in Elm. But sometimes we need to reach out to JavaScript, whether we're using ports, Custom Elements, or serverless functions. Sometimes JavaScript is just the right tool for the job.

If you're going to use JavaScript, then you may as well get the improved safety and tooling that TypeScript provides. Except that it adds an extra transpilation step. Working in Elm, that often feels like an unnecessary burden. As you may have guessed already, there is a way to get the best of both worlds!

## Running TypeScript on your .js files

I've been using this approach in all my projects lately and really enjoying the simplicity. Here's how it works:

- Add a `tsconfig.json` to your project as usual
- Enable the [`checkJs`](https://www.typescriptlang.org/tsconfig#checkJs) and [`allowJs`](https://www.typescriptlang.org/tsconfig#allowJs) options in your `tsconfig.json`

You'll now get type checking in your editor for the `.js` files you're working on! Alternatively, you can add a `// @ts-check` comment to the top of your `.js` files, but I prefer setting it for the whole project in my `tsconfig.json`.

You can also set the [`noEmit`](https://www.typescriptlang.org/tsconfig#noEmit) option in your `tsconfig.json` to make sure there is no transpilation output.

Be sure to run `tsc` in your builds to make sure that new code doesn't make it to production if there is a TypeScript compiler error. This is one of the reasons that transpiling may feel safer, because you won't even get JavaScript output when there are errors (unless you overide [`noEmitOnError`](https://www.typescriptlang.org/tsconfig#noEmitOnError) in your tsconfig 😳). I feel comfortable with that tradeoff, but it's very important to make sure your builds fail if there is a compiler error!

Sidenote: I recommend setting the [`strict`](https://www.typescriptlang.org/tsconfig#strict) option in your tsconfig to `true` to avoid pitfalls like implicit any. There are still pitfalls where you may have type errors even when TypeScript says your program compiles, but at least it gets you a lot closer to a sound type system. In a future post, I'll discuss when you can trust TypeScript and where it has blindspots.

Here's a sample `tsconfig.json` with this setup:

```javascript
{
  "compilerOptions": {
    "allowJs": true,
    "checkJs": true,
    "noEmit": true,
    // make the compiler as strict as possible
    "strict": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    // get intellisense for the available platform APIs
    "lib": ["dom", "es2020"],
  }
}
```

## Adding TypeScript types to your .js files with JSDoc comments

Once you've got the TypeScript compiler wired in for your project, you'll need to add type annotations and define TypeScript types so that you can work with TypeScript and use strict, explicit type checks.

You can include type information in `JSDoc` comments.

```javascript
/**
 * @param {Language} language
 * @param {string} name
 * @type {import("./user")} user
 * @returns {string}
 */
function greet(language, name, user) {
  /** @type {string} */
  let greeting;
  greeting = `${helloInLanguage(language)} ${name}`;
  const username = user.username;
  if (username) {
    greeting += ` (@${user.username})!`;
  }
  return greeting;
}

/** @typedef {"english" | "spanish"} Language */
```

Let's break down what's happening here.

- `/** ... */` defines a JSDoc comment
- `@param` defines a parameter (`name` is a parameter name for the `greet` function). You write one `@param` line for each parameter.
- The values between the `{}`'s (like `{string}`) can be any valid TypeScript type, including unions and other advanced types, or types defined in other files
- We can't `import` TypeScript types directly in code as we can in `.ts` files, but we can [use `import` within the `{}`s in JSDoc comments to refer to types in other files or NPM packages](https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html#import-types)
- The [`@type`](https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html#type) JSDoc comment lets us declare the type of the `greeting` variable
- We're using [`@typedef`](https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html#typedef-callback-and-param) to define a union type called `Language`, then specifying that the `language` parameter has that type.

In VS Code, you can start typing `/**` and it will code complete for all the parameter names in the function's parameter list. Also, since this is JSDoc, you can include documentation here and it will show up in your editor tooltips.

You can find a full list of supported [JSDoc TypeScript directives](https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html), and take a look at the [official TypeScript guide on using TypeScript in .js](https://www.typescriptlang.org/docs/handbook/intro-to-js-ts.html).

## What are the downsides?

Most TypeScript functionality is available using JSDoc comments. And, importantly, you can enforce TypeScript rules with the exact same strictness that a `.ts` file would allow.

The main limitation is that you don't have access to some TypeScript-specific syntax.

- `as`, also known as [type assertions](https://basarat.gitbook.io/typescript/type-system/type-assertion) (or casts)
- `is`, also known as [type predicates](https://www.typescriptlang.org/docs/handbook/advanced-types.html#using-type-predicates)
- `!`, non-null assertions

However, non-null assertions and `as` (casts) are two unsafe operators that, as the [TypeScript docs say](https://www.typescriptlang.org/docs/handbook/basic-types.html#type-assertions), let you tell the compiler "trust me, I know what I'm doing." As Elm developers, we want to avoid these as much as possible. So while there are some syntax features that aren't available in JSDoc-typed `.js` files, you can get most of what you need to take advantage of the added safety of TypeScript. And you can use the `@type` directive to perform type casts using JSDoc syntax as well.

## TypeScript in Elm

I'm writing this series of posts about using TypeScript with Elm in preparation for the upcoming launch of my redesigned `elm-ts-interop` tool. If you missed it, I wrote a post introducing some of the concepts in my post [Types Without Borders Isn't Enough](https://functional.christmas/2020/11). I'll be launching `elm-ts-interop` on March 1st, with a free set of core features, and some paid pro features to help with code generation.

Got any TypeScript for Elm users questions? Send them my way and I'll do my best to answer them!

---
mediaId: 02zQOjkbROx02LUBc69GvIw02EoSUvwEPkaHrKF011O2RRI
title: Setup
description: We install the NPM package, the InteropDefinitions file, and use it to generate TypeScript bindings for our Elm app's ports and flags.
free: true
---

## Install the NPM Package

```shell
npm install --save-dev elm-ts-interop
```

```shell
npx elm-ts-interop init
```

Generates TypeScript type bindings from our InteropDefinitions.elm file.

Choose an output filename for the generated TypeScript Declaration file [from the `elm-ts-interop` setup instructions](https://elm-ts-interop.com/setup/#choose-a-filename-for-your-generated-typescript-declarations).

```shell
npx elm-ts-interop --output src/Main.elm.d.ts
```

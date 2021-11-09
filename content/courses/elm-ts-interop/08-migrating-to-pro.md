---
title: Migrating to Pro
description: elm-ts-interop Pro has the same type-safety as the Community Edition, but with some added convenience.
start: video-demo-solution
solution: video-demo-pro-solution
---

Purchase the elm-ts-interop Pro Edition and find the scaffolding tool at [elm-ts-interop.com](https://elm-ts-interop.com/).

Use the equivalent generate command for our package.json `generate` script:

```shell
elm-ts-interop-pro --output src/Main.elm.d.ts --gen-directory gen --definitions src/InteropDefinitions.elm
```

[Copy the `.npmrc` file](https://github.com/dillonkearns/elm-ts-interop-starter/tree/pro), as indicated in the pro instructions.

We can generate our `Log.Kind` encoder by inputting this into [the Pro scaffolding tool](https://elm-ts-interop.com/ts-to-elm/):

```typescript
export type Kind = "error" | "warn" | "info" | "alert";
```

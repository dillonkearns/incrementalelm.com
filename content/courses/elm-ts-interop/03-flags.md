---
mediaId: ukOMTMbovbReAXDP71xSuAOYLk7vPUq44YJsKTcvHvI
title: Flags
description: We replace our flags decoder with an elm-ts-json Decoder to keep them in sync with TypeScript.
---

## Wire in the Flags

- `elm-ts-json` Decoder is a drop-in replacement for our original `elm/json` Flags `Decoder`
- Run elm-ts-interop in watch mode `npx elm-ts-interop --output src/Main.elm.d.ts --watch`
- Using `InteropPorts.decodeFlags` (the module from running `elm-ts-interop init`) ensures that our generated types and TypeScript types are in sync

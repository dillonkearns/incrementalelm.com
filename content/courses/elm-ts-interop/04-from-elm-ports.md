---
title: FromElm Ports
description: We replace our alert port with an elm-ts-json FromElm port to keep it in sync with TypeScript.
free: true
---

Replace our Vanilla port with our `FromElm` `elm-ts-interop` port:

```diff
LogMessage kind ->
    ( model
-   , alert model.input
+   , InteropPorts.fromElm ( InteropPorts.Alert model.input )
    )
```

Subscribe to the port from TypeScript using our single FromElm port:

```typescript
app.ports.interopFromElm.subscribe((fromElm) => {
  alert(fromElm.data.message);
});
```

Use `elm-ts-json` to the `Alert` port. Then add `logKind`:

```elm
fromElm : Encoder FromElm
fromElm =
    TsEncode.union
        (\vAlert value ->
            case value of
                Alert string ->
                    vAlert string
        )
        |> TsEncode.variantTagged "alert"
            (TsEncode.object
                [ required "message" (\value -> value.message) TsEncode.string
                , required "logKind" (\value -> value.kind) Log.encoder
                ]
            )
        |> TsEncode.buildUnion
```

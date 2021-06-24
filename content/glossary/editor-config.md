---
tags: setup
---

# Recommended Editor Configuration

My editor of choice is IntelliJ with the excellent [intellij-elm](https://github.com/klazuka/intellij-elm) plugin. You can [install the free IntelliJ Community Edition](https://www.jetbrains.com/idea/download), or use a paid JetBrains IDE (it will work just as well either way).

To see some of the great features of intellij-elm's features in action, take a look at the [feature demo gifs in the docs](https://github.com/klazuka/intellij-elm/tree/master/docs/features).

## IntelliJ Vim Configuration

If you like vim motions, it's worth [installing IdeaVim](https://plugins.jetbrains.com/plugin/164-ideavim).

There's also a somewhat hidden feature that you can enable some built-in emulated vim plugins. [These docs](https://github.com/JetBrains/ideavim/blob/master/doc/emulated-plugins.md) describe all the available plugins and how to enable them.

If you want to use my recommended setup, you can just copy-paste this into a file at `~/.ideavimrc`:

```viml
set surround
set commentary
set ReplaceWithRegister
set easymotion
set argtextobj
set exchange
set textobj-entire

let g:argtextobj_pairs="(:),{:},<:>,[:]"
```

## Remote Pairing

The [IntelliJ GitDuck plugin](https://plugins.jetbrains.com/plugin/14919-gitduck-pair-programming-tool) allows you to pair in either VS Code or `intellij-elm`.

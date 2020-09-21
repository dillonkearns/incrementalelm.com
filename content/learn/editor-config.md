---
{ "type": "learn", "title": "Recommended Editor Configuration" }
---

Right now, our editor of choice is Atom because of the excellent Elm tools available in that editor.

I'm closely watching the rapid and promising improvements in [the Intellij Elm plugin](https://github.com/klazuka/intellij-elm). At the moment it's missing some very useful features that Atom has support for, so it gets second place for me. Also, the Vim support is decent in Intellij, and outstanding in Atom, which is a big plus for me!

To see some of the great features of Atom's Elm integration in action, look at the [docs from the Elmjutsu Atom package](https://atom.io/packages/elmjutsu).

## Recommended Atom Configuration

First, download and install the [Atom editor](https://atom.io/).

You can install our recommended core Elm packages in one go by running this from your terminal after installing Atom:

```
apm install elmjutsu elm-lens elm-format atom-ide-ui language-elm
```

- [Elmjutsu](https://atom.io/packages/elmjutsu) - see link for a full list of functionality.
- [elm-lens](https://atom.io/packages/elm-lens) - annotates unused functions with warnings. Tells you if you have exposed functions with no external usage as well.
- [Atom IDE UI](https://atom.io/packages/atom-ide-ui) - provides a UI for displaying in-editor compiler errors & command-click to navigate to definition functionality.
- [elm-format package](https://atom.io/packages/elm-format) - runs `elm-format` on save in your editor. Requires that you've run `npm install -g elm-format`.

## Atom Vim Configuration

If you like Vim, Atom has the best Vim support of any editor I've used! It even has first-class integration with Atom's built-in multiple cursors feature. Here is our recommended setup:

```
apm install vim-mode-plus vim-mode-plus-keymaps-for-surround
```

See the docs for lots of details about the features in vim-mode-plus.

- [vim-mode-plus](https://atom.io/packages/vim-mode-plus)
- [vim-mode-plus surround keybindings](https://atom.io/packages/vim-mode-plus-keymaps-for-surround)

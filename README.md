# Neovim Config
Lighter weight code editing config.

This config is inspired by frameworks such as astro, lunar, and nvchad.
I have used those somewhat extensively and find them to be pretty great out of the box.
However, they generally include a lot of components I don't end up using and are (in some cases) harder to customize than I prefer.
Here, I make use of some modern neovim features that seem to enhance my workflow:

* lsp support
* winbars - no bufferline/tabline plugin(s)
* global status bar - better lsp status experience
* _lua_ - who really wants to write vimscript?

There is nothing magical here, just a simply organized and easy to configure.

## Current languages configured:
* rust
* lua
* javascript/typescript
* go (gopls)
* c# (omnisharp)

## Features
* Mason
* Telescope
* LSP
    * Diagnostics
    * Inlay hints
    * Code formatting
    * Completions
    * Lualine integration
* Which-Key
* Nvim Surround
* Lightspeed
* Lualine + Global status bar
* Dressing UI
* Illuminate
* Lir file manager
* Focus
* Cinnamon motions (for fun)
* Leaf theme (matches kde plasma)

## Some Configs
I tried to include most of the user tunable stuff in `init.lua`, there is a `lua/user_config` directory where some things
that might be install dependent can go, the `init.lua` in that directory will not be git committed.

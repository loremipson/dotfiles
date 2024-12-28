# Frontend Neovim Config

A minimal, efficient, opinionated (currently) neovim configuration

## Features

- Space as `<leader>`
- Typescript, React, Next, Node, Astro, Vue, Go, TailwindCSS
- Lazy plugin loading
- LSP
- AI support with Supermaven/CodeCompanion
- Formatting and linting with Conform/nvim-lint
- Lazygit
- Tmux navigation
- Telescope

## Install

```sh
git clone git@github.com:loremipson/nvim.git ~/.config
```

### Prerequisites

- Neovim 0.10+

## Configuration

To use CodeCompanion, you'll need to configure the API keys:

```sh
cd ~/.config/nvim && cp lua/defaults.lua config.lua
```

Now edit `config.lua` and add your desired API keys/configurations as [outlined here](https://github.com/olimorris/codecompanion.nvim?tab=readme-ov-file#electric_plug-adapters).

# Frontend Neovim Config

A minimal, efficient, opinionated Neovim configuration targeting frontend development.

## Features

- Space as `<leader>`
- TypeScript, React, Node, Lua, Astro, Vue, TailwindCSS
- Lazy plugin loading via lazy.nvim
- LSP via nvim-lspconfig + Mason (auto-installs servers)
- Autocompletion via blink.cmp with LuaSnip + friendly-snippets
- AI support via Supermaven (inline) and OpenCode (chat/agent)
- Formatting via Conform — oxlint/oxfmt, Biome, ESLint, Prettier, Stylua
- Linting via nvim-lint
- Git signs, Lazygit, and git log via Snacks
- Tmux pane navigation via Navigator.nvim
- Diagnostics and quickfix via Trouble.nvim
- TypeScript error translation via ts-error-translator
- TailwindCSS value inspection via tw-values
- Surround motions via nvim-surround
- Snacks.nvim — picker, notifier, input, indent guides, scroll, statuscolumn, scratch buffers, words, toggles
- Theme picker with live preview (`<leader>cs`)

## Themes

Four theme packages are included, switchable at any time via `<leader>cs`:

| Package | Variants |
|---|---|
| [Kanso](https://github.com/webhooked/kanso.nvim) | `kanso-ink`, `kanso-zen`, `kanso` |
| [Black Metal](https://github.com/metalelf0/black-metal-theme-neovim) | 16 bands × default + alt (32 total) |
| [Neomodern](https://github.com/casedami/neomodern.nvim) | `moon`, `iceclimber`, `gyokuro`, `hojicha`, `roseprime` |
| [Monokai Pro](https://github.com/loctvl842/monokai-pro.nvim) | `pro`, `classic`, `machine`, `octagon`, `ristretto`, `spectrum` |

The picker live-previews each theme against your current buffer as you browse. Your selection persists across restarts (saved to `~/.local/share/nvim/colorscheme.txt`). Press `<leader>tB` to toggle light/dark mode for themes that support it (Neomodern, Black Metal).

## Keymaps

### General

| Key | Action |
|---|---|
| `jj` | Exit insert mode |
| `<leader>cs` | Theme picker |

### Files & Search (Snacks picker)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` | Resume last picker |
| `<leader>fs` | LSP symbols (buffer) |
| `<leader>fS` | LSP symbols (workspace) |
| `<leader>fc` | Git log |
| `<leader>fw` | Grep word under cursor |
| `<leader>fy` | Registers |
| `<leader>f/` | Search history |
| `<leader>f:` | Command history |

### Git

| Key | Action |
|---|---|
| `<leader>gg` | Lazygit |
| `<leader>gl` | Lazygit log |
| `<leader>gf` | Lazygit file history |

### Toggles

| Key | Action |
|---|---|
| `<leader>ts` | Spelling |
| `<leader>tw` | Line wrap |
| `<leader>tl` | Line numbers |
| `<leader>tL` | Relative line numbers |
| `<leader>tD` | Diagnostics |
| `<leader>tT` | Treesitter |
| `<leader>tB` | Dark/light background |
| `<leader>th` | Inlay hints |
| `<leader>tg` | Indent guides |
| `<leader>tm` | Dim (focus mode) |
| `<leader>tc` | Conceal level |

### Scratch Buffers

| Key | Action |
|---|---|
| `<leader>.` | Toggle scratch buffer |
| `<leader>S` | Select scratch buffer |

## Install

```sh
git clone git@github.com:loremipson/nvim.git ~/.config
```

### Prerequisites

- Neovim 0.11+
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- `node` in `$PATH` (for TypeScript scratch buffer runner)
- `lazygit` in `$PATH` (optional, for git UI)

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Check if running inside VSCode/Cursor
local is_vscode = vim.g.vscode ~= nil

local plugins = {
  {
    'rose-pine/neovim',
    cond = not is_vscode,
    config = function()
      require('plugin-configs.rose-pine').setup()
    end,
  },
  {
    'ibhagwan/fzf-lua',
    cond = not is_vscode,
    config = function()
      require('plugin-configs.fzf-lua').setup()
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'RRethy/nvim-treesitter-textsubjects',
    },
    config = function()
      require('plugin-configs.treesitter').setup()
    end,
  },
  {
    'williamboman/mason.nvim',
    cond = not is_vscode,
    dependencies = {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('plugin-configs.mason').setup()
    end,
  },
  {
    'neovim/nvim-lspconfig',
    cond = not is_vscode,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'antosha417/nvim-lsp-file-operations', config = true },
    },
    config = function()
      require('plugin-configs.nvim-lspconfig').setup()
    end,
  },
  {
    'saghen/blink.cmp',
    cond = not is_vscode,
    version = 'v0.*',
    config = function()
      require('plugin-configs.blink-cmp').setup()
    end,
  },
  {
    'numToStr/Comment.nvim',
    lazy = false,
    dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      require('Comment').setup()
    end,
  },
  {
    'supermaven-inc/supermaven-nvim',
    cond = not is_vscode,
    config = function()
      require('supermaven-nvim').setup {}
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    cond = not is_vscode,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('plugin-configs.codecompanion').setup()
    end,
  },
  {
    'numToStr/Navigator.nvim',
    cond = not is_vscode,
    config = function()
      require('plugin-configs.navigator').setup()
    end,
  },
  {
    'stevearc/conform.nvim',
    cond = not is_vscode,
    cmd = 'ConformInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('plugin-configs.conform').setup()
    end,
  },
  {
    'mfussenegger/nvim-lint',
    cond = not is_vscode,
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('plugin-configs.nvim-lint').setup()
    end,
  },
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    cond = not is_vscode,
    config = function()
      require('plugin-configs.git-signs').setup()
    end,
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cond = not is_vscode,
  },
  {
    'ray-x/go.nvim',
    cond = not is_vscode,
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()',
  },
  {
    'folke/trouble.nvim',
    cond = not is_vscode,
    config = function()
      require('plugin-configs.trouble').setup()
    end,
  },
  {
    'folke/snacks.nvim',
    cond = not is_vscode,
    priority = 1000,
    lazy = false,
    config = function()
      require('plugin-configs.snacks').setup()
    end,
  },
  {
    'folke/which-key.nvim',
    dependencies = { 'echasnovski/mini.icons' },
    event = 'VeryLazy',
    config = function()
      require('plugin-configs.which-key').setup()
    end,
  },
}

require('lazy').setup(plugins)

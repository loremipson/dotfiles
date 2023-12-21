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

local plugins = {
  {
    'rose-pine/neovim',
    config = function()
      require('plugin-configs.rose-pine').setup()
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('plugin-configs.telescope').setup()
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('plugin-configs.treesitter').setup()
    end,
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    config = function()
      require('plugin-configs.lsp-zero').setup()
    end,
  },
  {
    'williamboman/mason.nvim',
    config = function()
      require('plugin-configs.mason').setup()
    end,
  },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/cmp-nvim-lsp' },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind.nvim',
    },
    config = function()
      require('plugin-configs.nvim-cmp').setup()
    end,
  },
  {
    'Exafunction/codeium.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'hrsh7th/nvim-cmp' },
    config = function()
      require('codeium').setup {}
    end,
  },
  {
    'numToStr/Navigator.nvim',
    config = function()
      require('plugin-configs.navigator').setup()
    end,
  },
  {
    'stevearc/conform.nvim',
    cmd = 'ConformInfo',
    config = function()
      require('plugin-configs.conform').setup()
    end,
  },
  {
    'mfussenegger/nvim-lint',
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
    'nvim-neotest/neotest',
    event = 'LspAttach',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'marilari88/neotest-vitest',
    },
    config = function()
      require('plugin-configs.neotest').setup()
    end,
  },
  {
    'kdheepak/lazygit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('plugin-configs.lazygit').setup()
    end,
  },
  { 'folke/todo-comments.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
}

require('lazy').setup(plugins)

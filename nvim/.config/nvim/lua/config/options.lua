local options = {
		hlsearch       = false, -- Set highlight on search
		number         = true, -- Make line numbers default
		relativenumber = true,
		mouse          = 'a', -- Enable mouse mode
		clipboard      = 'unnamedplus', -- sync clipboard to os
		breakindent    = true, -- Enable break indent
		undofile       = true, -- Save undo history
		ignorecase     = true, -- case insensitive searching
		smartcase      = true, -- unless /C or caps in search
		signcolumn     = 'yes', -- Keep signcolumn on by default
		updatetime     = 250, -- Decrease update time
		timeout        = true,
		shiftwidth     = 2, -- Change a number of space characeters inseted for indentation
		showtabline    = 2, -- Always show tabs
		smartindent    = true, --- Makes indenting smart
		smarttab       = true, --- Makes tabbing smarter will realize you have 2 vs 4
		softtabstop    = 2, --- Insert 2 spaces for a tab
		splitright     = true, --- Vertical splits will automatically be to the right
		swapfile       = false, --- Swap not needed
		tabstop        = 2, --- Insert 2 spaces for a tab
		timeoutlen     = 300, -- faster completion, must be above 200
		completeopt    = 'menuone,noselect', -- better autocomplete
		termguicolors  = true, -- correct terminal colors
}

local globals = {
		mapleader = ' ',
		maplocalleader = ' '
}

for k, v in pairs(options) do
	vim.o[k] = v
end

for k, v in pairs(globals) do
	vim.g[k] = v
end

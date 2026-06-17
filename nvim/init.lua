-- General ConfigG
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'no'
vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false -- tab superiority
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cmdheight = 0
vim.opt.showmode = false
vim.opt.swapfile = false
vim.opt.fillchars = { eob = " " } -- hide "~" on empty lines
vim.opt.mouse = "nv"

vim.opt.clipboard:append("unnamedplus")

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Why does this have to be run as an autocommand?
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "r", "o" })
  end,
})

-- General Keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<M-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<M-k>", ":m .-2<CR>==", { desc = "Move line up" })

vim.keymap.set("v", "<", "<gv", { desc = "indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "indent right and reselect" })

-- Plugins
vim.pack.add({
    "https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/romus204/tree-sitter-manager.nvim",
})

local function packadd(name)
	vim.cmd("packadd " .. name)
end

-- Plugins are stored in ~/.local/share/nvim/site/pack/core/opt
-- Delete plugins here by pressing `gra` over it (for some reason)
vim.keymap.set("n", "<leader>vpu", function()
	vim.pack.update(nil, { offline = true })
end, { desc = "Open parent directory" })

-- Silly little icons for the few things that use it
packadd("nvim-web-devicons")

-- Oil
packadd("oil.nvim")
require("oil").setup({
	columns = {
		"permissions",
		"mtime",
		"size",
		"icon",
	},
	view_options = {
		show_hidden = true,
	},
})

vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Pairs ^-^
packadd("mini.pairs")
require("mini.pairs").setup()

-- Status Line
-- As stripped as possible...
packadd("lualine.nvim")
require("lualine").setup({
	options = {
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'diagnostics', 'location'},
		lualine_y = {},
		lualine_z = {},
	},
})

-- Lua Fzf
packadd("fzf-lua")
require("fzf-lua").setup({'fzf-native'})
-- require("fzf-lua").setup({'fzf-vim'}) 

vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").files()
end, { desc = "FZF Files" })

vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "FZF Live Grep" })

vim.keymap.set("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "FZF Buffers" })

vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").help_tags()
end, { desc = "FZF Help Tags" })

-- Treesitter - Managing Parsers (functionality native to nvim)
-- `:TSManager` and `:checkhealth vim.treesitter`
packadd("tree-sitter-manager.nvim")
require("tree-sitter-manager").setup({
	auto_install = true,
	nerdfont = false,
})

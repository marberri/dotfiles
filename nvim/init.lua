-- General Config
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'no'
vim.opt.wrap = true
vim.opt.textwidth = 80 -- use gq
vim.opt.linebreak = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
vim.opt.termguicolors = true

vim.opt.winborder = "rounded"
vim.opt.cmdheight = 0
vim.opt.showmode = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.fillchars = { eob = " " } -- hide "~" on empty lines
vim.opt.mouse = "nv"
vim.opt.scrolloff = 8

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
	"https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/romus204/tree-sitter-manager.nvim",
	{ src = "https://codeberg.org/evergarden/nvim.git", name = "evergarden" },
	"https://github.com/neovim/nvim-lspconfig",
})

local function packadd(name)
	vim.cmd("packadd " .. name)
end

-- Plugins are stored in ~/.local/share/nvim/site/pack/core/opt
-- Delete plugins here by pressing `gra` over it (for some reason)
vim.keymap.set("n", "<leader>vpu", function()
	vim.pack.update(nil, { offline = true })
end)

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

-- Status Line
packadd("lualine.nvim")
require("lualine").setup({
	options = {
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'filename'},
		lualine_c = {},
		lualine_x = {'location'},
		lualine_y = {'lsp_status'},
		lualine_z = {'filetype'},
	},
})

-- Lua Fzf
packadd("fzf-lua")
-- require("fzf-lua").setup({'default'})
require("fzf-lua").setup({'telescope'})

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

vim.keymap.set("n", "<leader>fd", function()
	require("fzf-lua").diagnostics_document()
end, { desc = "FZF LSP Diagnostics" })


-- Treesitter - Managing Parsers (functionality native to nvim)
-- `:TSManager` and `:checkhealth vim.treesitter`
packadd("tree-sitter-manager.nvim")
require("tree-sitter-manager").setup({
	auto_install = true,
	noauto_install = {
		"c", "lua", "markdown", "markdown_inline", "query", "vim", "vimdoc"
	},
})

-- Colorscheme
packadd("evergarden")
vim.o.background = "dark"
require("evergarden").setup({
  theme = {
    variant = 'winter', -- 'winter'|'fall'|'spring'|'summer'
    accent = 'green',
  },
  editor = {
	  override_terminal = true,
  },
})
vim.cmd.colorscheme("evergarden")

-- Automatically trim trailing whitespace (lowkey stolen from somewhere, but useful)
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = {"*"},
    callback = function()
      local save_cursor = vim.fn.getpos(".")
      pcall(function() vim.cmd [[%s/\s\+$//e]] end) -- magic to my brain
      vim.fn.setpos(".", save_cursor)
    end,
})

-- Native Lsp...
packadd("nvim-lspconfig")
vim.lsp.enable({"lua_ls", "clangd" })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
-- 		local client = vim.lsp.get_client_by_id(ev.data.client_id)
-- 		if client:supports_method('textDocument/completion') then
-- 			vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})
-- 		end

		vim.diagnostic.config({ virtual_text = false, virtual_lines = false, underline = false })
	end,
})

-- Worst thing ever
vim.api.nvim_set_hl(0, "Error", { link = "Normal" })


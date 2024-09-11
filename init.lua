-- Visual
vim.opt.cursorline = true
vim.opt.guicursor = ""
vim.opt.linebreak = true
vim.opt.listchars:append({ tab = "» ", eol = "¬", trail = "·" })
vim.opt.scrolloff = 6
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.wrap = false

-- Handling
vim.opt.autowrite = true
vim.opt.formatoptions = vim.opt.formatoptions + "r"
vim.opt.ignorecase = true
vim.opt.joinspaces = false
vim.opt.mouse = "a"
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.switchbuf = "useopen,vsplit"
vim.opt.wildignorecase = true

-- Indent
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

-- Leader
vim.g.mapleader = " "

-- Disable Ex mode
vim.keymap.set("n", "Q", "<Nop>")

-- Basics
vim.keymap.set("n", "<leader>q", "<cmd>%s/\\s\\+$//<cr>:noh<cr>", { desc = "Remove trailing whitespace" })
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>h", "<cmd>noh<cr>", { desc = "Clear highlight" })
vim.keymap.set("v", "@", "<cmd>normal @", { silent = true, desc = "Replay macro" })
vim.keymap.set("v", "p", "P", { noremap = true, silent = true }) -- Don't yank on paste
vim.keymap.set("n", "yof", function()
	if vim.opt_local.formatoptions:get().a then
		vim.opt_local.formatoptions:remove("a")
		print("Auto wordwrap disabled")
	else
		vim.opt_local.formatoptions:append("a")
		print("Auto wordwrap enabled")
	end
end, { desc = "Toggle auto wordwrap" })

-- Window movement
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-l>", "<c-w>l")

-- Code movement
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- Search movement
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- System clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste from system clipboard" })

-- Encoding
vim.opt.fileencodings = "ucs-bom,utf-8,cp932,default"
vim.keymap.set("n", "<leader>z", ":e ++enc=cp932", { desc = "Reopen as Shift-JIS" })

-- LSP
vim.keymap.set("n", "<leader>a", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", { desc = "Format document" })
vim.keymap.set("n", "<leader>ci", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
vim.keymap.set("n", "<leader>cI", "<cmd>LspInstallInfo<cr>", { desc = "LSP Install Info" })
vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code action" })
vim.keymap.set("n", "<leader>cj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>ck", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", { desc = "Prev diagnostic" })
vim.keymap.set("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" })
vim.keymap.set("n", "<leader>cs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Signature help" })
vim.keymap.set("n", "<leader>cq", "<cmd>lua vim.diagnostic.setloclist()<cr>", { desc = "Set loc list" })

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>")

require("lazy").setup({
	"chamindra/marvim",
	"editorconfig/editorconfig-vim",
	"maxbrunsfeld/vim-yankstack",
	"mg979/vim-visual-multi",
	"nvim-treesitter/nvim-treesitter",
	"sheerun/vim-polyglot",
	"tpope/vim-repeat",
	"tpope/vim-surround",
	"tpope/vim-unimpaired",

	{
		"farmergreg/vim-lastplace",
		config = function()
			vim.g.lastplace_ignore = "gitcommit"
		end,
	},

	{
		"folke/which-key.nvim",
		dependencies = { "afreakk/unimpaired-which-key.nvim" },
		config = function()
			local wk = require("which-key")
			wk.setup({
				preset = "helix",
				delay = 1000,
				win = {
					padding = { 1, 1 },
					border = "none",
				},
			})
			wk.add(require("unimpaired-which-key"))
		end,
	},

	-- Visual

	{
		"jacoborus/tender.vim",
		config = function()
			vim.cmd([[colorscheme tender]])
			vim.cmd([[hi Normal guifg=#eeeeee ctermfg=255 guibg=#1e1e1e ctermbg=234 gui=NONE cterm=NONE]])
			vim.cmd([[hi VertSplit guifg=#3a3a3a ctermfg=237 guibg=#1e1e1e ctermbg=234]])
		end,
	},

	{
		"itchyny/lightline.vim",
		config = function()
			vim.g.lightline = { colorscheme = "wombat" }
		end,
	},

	-- Telescope

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzy-native.nvim" },
			{ "BurntSushi/ripgrep" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "vertical",
					mappings = {
						i = {
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
						},
					},
				},
				pickers = {
					buffers = { sort_lastused = true },
					find_files = {
						previewer = false,
						find_command = { "fd" },
					},
					git_files = { previewer = false },
					man_pages = { sections = { "ALL" } },
				},
				extensions = {
					fzy_native = {
						override_generic_sorter = false,
						override_file_sorter = true,
					},
				},
			})
			require("telescope").load_extension("fzy_native")
			builtins = require("telescope.builtin")
			vim.keymap.set("n", "<leader>r", builtins.resume, { desc = "Telescope resume" })
			vim.keymap.set("n", "<leader>d", builtins.buffers, { desc = "Goto buffer" })
			vim.keymap.set("n", "<leader>f", builtins.find_files, { desc = "Goto file" })
			vim.keymap.set("n", "<leader>F", function()
				builtins.find_files({ hidden = true, no_ignore = true })
			end, { desc = "Goto file (hidden)" })
			vim.keymap.set("n", "<leader>s", builtins.live_grep, { desc = "Search in files" })
			vim.keymap.set("n", "<leader>S", builtins.grep_string, { desc = "Search word in files" })
			vim.keymap.set("n", "<leader>g", builtins.git_files, { desc = "Goto file (git)" })
			vim.keymap.set("n", "<leader>m", builtins.man_pages, { desc = "Goto man-page" })
			vim.keymap.set("n", "<leader>n", function()
				builtins.find_files({ cwd = "~/git/notes" })
			end, { desc = "Goto notes" })
			vim.keymap.set("n", "<leader>N", function()
				builtins.live_grep({ cwd = "~/git/notes" })
			end, { desc = "Search in notes" })
		end,
	},

	-- LSP

	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local on_attach = function(client, bufnr)
				local opts = { noremap = true, silent = true }
				vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
				vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
				vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
				vim.api.nvim_buf_set_keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
				vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
				vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
			end
		end,
	},

	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
				},
			})
		end,
	},
})

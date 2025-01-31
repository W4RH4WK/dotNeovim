-- Functions
function isTTY()
	return vim.env.TERM == "linux"
end

-- Visual
vim.opt.guicursor = ""
vim.opt.listchars:append({ tab = "» ", eol = "¬", trail = "·" })
vim.opt.scrolloff = 6
vim.opt.signcolumn = "no"
vim.opt.termguicolors = not isTTY()

-- Handling
vim.opt.autowrite = true
vim.opt.completeopt = "menu,preview"
vim.opt.joinspaces = false
vim.opt.swapfile = false
vim.opt.switchbuf = "useopen,vsplit"
vim.opt.wildignorecase = true

-- Indent
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Leader
vim.g.mapleader = " "

-- Basics
vim.keymap.set("n", "<leader>q", "<cmd>%s/\\s\\+$//<cr>:noh<cr>", { desc = "Trim trailing whitespace" })
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>e", "<cmd>w<cr><cmd>silent make<cr><cmd>cwindow<cr>", { desc = "Build" })
vim.keymap.set("n", "<leader>h", "<cmd>noh<cr>", { desc = "Clear highlight" })
vim.keymap.set("v", "@", "<cmd>normal @", { silent = true, desc = "Replay macro" })

-- Buffer switch
vim.keymap.set("n", "<leader>`", "<c-6>", { desc = "Prev buffer" })

-- Search movement
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Encoding
vim.opt.fileencodings = "ucs-bom,utf-8,cp932,default"
vim.keymap.set("n", "<leader>z", ":e ++enc=cp932", { desc = "Reopen as Shift-JIS" })

-- LSP
vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", { desc = "Format code" })
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
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

require("lazy").setup({
	{
		"rebelot/kanagawa.nvim",
		config = function()
			if isTTY() then
				return
			end
			require("kanagawa").setup({
				commentStyle = { italic = false },
				keywordStyle = { italic = false },
			})
			vim.cmd("colorscheme kanagawa")
		end,
	},

	"sheerun/vim-polyglot",
	-- "maxbrunsfeld/vim-yankstack",
	"mg979/vim-visual-multi",
	-- "tpope/vim-repeat",
	"editorconfig/editorconfig-vim",

	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.basics").setup({
				mappings = {
					windows = true,
					move_with_alt = true,
				},
			})

			local miniclue = require("mini.clue")
			miniclue.setup({
				clues = {
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
				},
				triggers = {
					{ mode = "x", keys = "<Leader>" },
					{ mode = "n", keys = "<Leader>" },
					{ mode = "x", keys = "<Leader>" },
					{ mode = "i", keys = "<C-x>" },
					{ mode = "n", keys = "g" },
					{ mode = "x", keys = "g" },
					{ mode = "n", keys = "'" },
					{ mode = "n", keys = "`" },
					{ mode = "x", keys = "'" },
					{ mode = "x", keys = "`" },
					{ mode = "n", keys = '"' },
					{ mode = "x", keys = '"' },
					{ mode = "i", keys = "<C-r>" },
					{ mode = "c", keys = "<C-r>" },
					{ mode = "n", keys = "<C-w>" },
					{ mode = "n", keys = "z" },
					{ mode = "x", keys = "z" },
				},
				window = {
					config = {
						width = "auto",
					},
				},
			})

			require("mini.ai").setup()
			require("mini.align").setup()
			require("mini.bracketed").setup()
			require("mini.comment").setup()
			require("mini.icons").setup()
			require("mini.pairs").setup()
			require("mini.statusline").setup()
			require("mini.surround").setup()
		end,
	},

	{
		"farmergreg/vim-lastplace",
		config = function()
			vim.g.lastplace_ignore = "gitcommit"
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
			end, { desc = "Goto file (all files)" })
			vim.keymap.set("n", "<leader>s", builtins.live_grep, { desc = "Search in files" })
			vim.keymap.set("n", "<leader>S", builtins.grep_string, { desc = "Search word in files" })
			vim.keymap.set("n", "<leader>g", builtins.git_files, { desc = "Goto file (git)" })
			vim.keymap.set("n", "<leader>m", builtins.man_pages, { desc = "Goto man-page" })
			vim.keymap.set("n", "<leader><tab>", builtins.jumplist, { desc = "Goto jumplist" })
			vim.keymap.set("n", "<leader>n", function()
				builtins.find_files({ cwd = "~/git/notes" })
			end, { desc = "Goto notes" })
			vim.keymap.set("n", "<leader>N", function()
				builtins.live_grep({ cwd = "~/git/notes" })
			end, { desc = "Search in notes" })
		end,
	},

	-- Treesitter

	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"c",
					"markdown",
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "markdown", "ruby" },
				},
			})
		end,
	},

	-- LSP

	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local on_attach = function(client, bufnr)
				local opts = { noremap = true, silent = true }
				-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
				-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
				-- vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
				-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
				-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
				-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
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
					null_ls.builtins.formatting.clang_format,
				},
			})
		end,
	},
})

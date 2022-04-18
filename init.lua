-- Visual
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.guicursor = ''
vim.opt.linebreak = true
vim.opt.listchars:append({tab = '» ', eol = '¬', trail = '·'})
vim.opt.scrolloff = 6
vim.opt.showmode = false

-- Handling
vim.opt.autowrite = true
vim.opt.swapfile = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.formatoptions = 'cjqrt'
vim.opt.mouse = 'a'
vim.opt.joinspaces = false

-- Encoding
vim.opt.fileencodings = 'ucs-bom,utf-8,cp932,default'

-- Indent
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Notes
vim.api.nvim_set_keymap('n', '<F1>', '<cmd>:help notes<cr>', {noremap = true})
vim.api.nvim_set_keymap('i', '<F1>', '<Nop>', {noremap = true})

-- Disable Ex mode
vim.api.nvim_set_keymap('n', 'Q', '<Nop>', {noremap = true})

-- Disable forward / backward (tmux)
vim.api.nvim_set_keymap('n', '<c-b>', '<Nop>', {noremap = true})
vim.api.nvim_set_keymap('n', '<c-f>', '<Nop>', {noremap = true})

-- Window movement
vim.api.nvim_set_keymap('n', '<c-h>', '<c-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<c-j>', '<c-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<c-k>', '<c-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<c-l>', '<c-w>l', {noremap = true})

-- Macro replay
vim.api.nvim_set_keymap('v', '@', '<cmd>normal @', {noremap = true, silent = true})

-- Toggle auto wordwrap
vim.api.nvim_set_keymap('n', 'yof', ':<C-U>setlocal <C-R>=(&formatoptions =~# "a") ? "formatoptions-=a" : "formatoptions+=a"<CR><CR>', {noremap = true})

-- Smarttab
vim.api.nvim_set_keymap('i', '<S-TAB>', '<TAB>', {noremap = true})
vim.api.nvim_set_keymap('i', '<TAB>', '<C-R>=SmartTab()<CR>', {noremap = true, silent = true})

-- Trim trailing whitespace
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>%s/\\s\\+$//<CR>:noh<CR>', {noremap = true})

-- Terminal
vim.api.nvim_set_keymap('n', '<leader>x', '<cmd>:terminal<CR>', {noremap = true})
vim.api.nvim_set_keymap('t', '<esc>', '<c-\\><c-n>', {noremap = true})

-- Encoding
vim.api.nvim_set_keymap('n', '<leader>j', ':e ++enc=cp932', {noremap = true})

-- Sidebar
-- vim.g.netrw_banner = false
-- vim.g.netrw_winsize = 25
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_browse_split = 4
-- vim.g.netrw_altv = 1
-- vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>Lexplore<CR>', {noremap = true})

-- Packages
vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost ~/.config/nvim/init.lua source <afile> | PackerCompile
	augroup end
]])

local packer = require('packer')
packer.startup(function(use)
	use 'wbthomason/packer.nvim'

	-- Theme
	use {'jacoborus/tender.vim', config = 'vim.cmd[[colorscheme tender]]'}
	use {'itchyny/lightline.vim', config = 'vim.g.lightline = {colorscheme = "wombat"}'}

	-- Handling
	use 'editorconfig/editorconfig-vim'
	use 'tpope/vim-repeat'
	use 'tpope/vim-surround'
	use 'tpope/vim-unimpaired'
	use 'mg979/vim-visual-multi'
	use 'chamindra/marvim'
	use {'numToStr/Comment.nvim',
		tag = 'v0.6',
		config = 'require("Comment").setup()'
	}
	use {'farmergreg/vim-lastplace', config = 'vim.g.lastplace_ignore = "gitcommit"'}

	-- Syntax
	use 'nvim-treesitter/nvim-treesitter'
	use 'sheerun/vim-polyglot'

	-- Telescope
	use {'nvim-telescope/telescope.nvim',
		requires = {
			{'nvim-lua/plenary.nvim'},
			{'nvim-telescope/telescope-fzy-native.nvim'},
		},
		config = function()
			require('telescope').setup {
				defaults = {
					mappings = {
						i = {
							['<C-j>'] = 'move_selection_next',
							['<C-k>'] = 'move_selection_previous',
						}
					}
				},
				extensions = {
					fzy_native = {
						override_generic_sorter = false,
						override_file_sorter = true,
					}
				}
			}
			require('telescope').load_extension('fzy_native')
			vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>Telescope buffers<cr>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>Telescope find_files find_command=fd previewer=false<cr>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>F', '<cmd>Telescope find_files find_command=fd previewer=false hidden=true no_ignore=true<cr>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>Telescope live_grep<cr>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>G', '<cmd>Telescope grep_string<cr>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>Telescope git_files previewer=false<cr>', {noremap = true})
		end
	}

	-- Toggleterm
	use {'akinsho/toggleterm.nvim',
		config = function()
			require('toggleterm').setup({
					open_mapping = [[<c-\>]],
					direction = 'float',
					float_opts = {
						border = 'curved'
					}
				})
		end
	}

	-- Sidebar
	use {'kyazdani42/nvim-tree.lua',
		config = function()
			vim.g.nvim_tree_show_icons = {
				folders = 1,
				files = 0,
				git = 0,
				folder_arrows = 0,
			}
			vim.g.nvim_tree_icons = {
				folder = {
					arrow_open = "▾",
					arrow_closed = "▸",
					default = "▸",
					open =  "▾",
					empty = "▸",
					empty_open = "▾",
					symlink = "▸",
					symlink_open = "▾",
				},
			}
			local tree_cb = require('nvim-tree.config').nvim_tree_callback
			require('nvim-tree').setup({
					renderer = {
						indent_markers = {
							enable = true,
						},
					},
					view = {
						mappings = {
							custom_only = false,
							list = {
								{ key = 's', action = '' },
								{ key = '<C-k>', action = '' },
							},
						},
					},
				})
			vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>NvimTreeToggle<cr>', {noremap = true})
		end
	}

	-- LSP
	use 'neovim/nvim-lspconfig'
	use {'jose-elias-alvarez/null-ls.nvim',
		config = function()
			local null_ls = require('null-ls')
			null_ls.setup({
					sources = {
						null_ls.builtins.formatting.clang_format
					}
				})
			vim.api.nvim_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.formatting()<cr>', {noremap = true})
		end
	}
end)

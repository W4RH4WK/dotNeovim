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
vim.keymap.set('n', '<F1>', '<cmd>:help notes<cr>')
vim.keymap.set('i', '<F1>', '<Nop>')

-- Disable Ex mode
vim.keymap.set('n', 'Q', '<Nop>')

-- Remap delete word
vim.keymap.set('i', '<c-w>', '<Nop>')
vim.keymap.set('i', '', '<c-w>')

-- Disable forward / backward (tmux)
vim.keymap.set('n', '<c-b>', '<Nop>')
vim.keymap.set('n', '<c-f>', '<Nop>')

-- Window movement
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

-- Macro replay
vim.keymap.set('v', '@', '<cmd>normal @', {silent = true})

-- Toggle auto wordwrap
vim.keymap.set('n', 'yof', ':<C-U>setlocal <C-R>=(&formatoptions =~# "a") ? "formatoptions-=a" : "formatoptions+=a"<CR><CR>')

-- Smarttab
vim.keymap.set('i', '<S-TAB>', '<TAB>')
vim.keymap.set('i', '<TAB>', '<C-R>=SmartTab()<CR>', {silent = true})

-- Trim trailing whitespace
vim.keymap.set('n', '<leader>q', '<cmd>%s/\\s\\+$//<CR>:noh<CR>')

-- Terminal
vim.keymap.set('n', '<leader>x', '<cmd>:terminal<CR>')
vim.keymap.set('t', '<esc>', '<c-\\><c-n>')

-- Encoding
vim.keymap.set('n', '<leader>j', ':e ++enc=cp932')

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
		config = 'require("Comment").setup()'
	}
	use {'farmergreg/vim-lastplace', config = 'vim.g.lastplace_ignore = "gitcommit"'}

	-- Syntax
	use 'nvim-treesitter/nvim-treesitter'
	use 'sheerun/vim-polyglot'

	-- Toggleterm
	use {'akinsho/toggleterm.nvim',
		config = function()
			require('toggleterm').setup {
				open_mapping = [[<c-\>]],
				direction = 'tab',
			}
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
			require('nvim-tree').setup {
				renderer = { indent_markers = { enable = true } },
				view = {
					mappings = {
						custom_only = false,
						list = {
							{ key = 's', action = '' },
							{ key = '<C-k>', action = '' },
						},
					},
				},
			}
			vim.keymap.set('n', '<leader>n', require('nvim-tree').toggle)
		end
	}

	-- Telescope
	use {'nvim-telescope/telescope.nvim',
		requires = {
			{'nvim-lua/plenary.nvim'},
			{'nvim-telescope/telescope-fzy-native.nvim'},
			{'BurntSushi/ripgrep'},
		},
		config = function()
			require('telescope').setup {
				defaults = {
					mappings = {
						i = {
							['<C-j>'] = 'move_selection_next',
							['<C-k>'] = 'move_selection_previous',
						},
					},
				},
				pickers = {
					find_files = {
						previewer = false,
						find_command = {'fd'},
					},
					git_files = { previewer = false },
					man_pages = { sections = {'ALL'} },
				},
				extensions = {
					fzy_native = {
						override_generic_sorter = false,
						override_file_sorter = true,
					},
				},
			}
			require('telescope').load_extension('fzy_native')
			builtins = require('telescope.builtin')
			vim.keymap.set('n', '<leader>b', builtins.buffers)
			vim.keymap.set('n', '<leader>f', builtins.find_files)
			vim.keymap.set('n', '<leader>F', function() builtins.find_files({hidden = true, no_ignore = true}) end)
			vim.keymap.set('n', '<leader>g', builtins.live_grep)
			vim.keymap.set('n', '<leader>G', builtins.grep_string)
			vim.keymap.set('n', '<leader>t', builtins.git_files)
			vim.keymap.set('n', '<leader>m', builtins.man_pages)
		end
	}

	-- LSP
	use 'neovim/nvim-lspconfig'
	use {'jose-elias-alvarez/null-ls.nvim',
		config = function()
			local null_ls = require('null-ls')
			null_ls.setup {
				sources = {
					null_ls.builtins.formatting.clang_format,
				},
			}
			vim.keymap.set({'n', 'v'}, '<leader>a', vim.lsp.buf.formatting)
		end
	}
end)

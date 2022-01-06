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
vim.g.netrw_banner = false
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>Lexplore<CR>', {noremap = true})

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

	---- Handling
	use 'tpope/vim-repeat'
	use 'tpope/vim-surround'
	use 'tpope/vim-unimpaired'
	use 'mg979/vim-visual-multi'
	use {'numToStr/Comment.nvim', config = 'require("Comment").setup()'}
	use {'farmergreg/vim-lastplace', config = 'vim.g.lastplace_ignore = "gitcommit"'}

	---- Syntax
	use 'nvim-treesitter/nvim-treesitter'
	use 'sheerun/vim-polyglot'

	---- Formatting
	use 'editorconfig/editorconfig-vim'
	use {'vim-autoformat/vim-autoformat',
		config = function()
			vim.api.nvim_set_keymap('n', '<leader>a', '<cmd>Autoformat<cr>', {noremap = true})
		end
	}

	---- Telescope
	use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/plenary.nvim'}},
		config = function()
			require('telescope').setup {
				defaults = {
					mappings = {
						i = {
							['<C-j>'] = 'move_selection_next',
							['<C-k>'] = 'move_selection_previous',
						}
					}
				}
			}
			vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>Telescope buffers<cr>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>Telescope find_files<cr>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>F', '<cmd>Telescope find_files hidden=true no_ignore=true<cr>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>Telescope live_grep<cr>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>Telescope git_files<cr>', {noremap = true})
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

	---- Completion
	--use 'neovim/nvim-lspconfig'
	
end)

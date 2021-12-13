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
vim.api.nvim_set_keymap('n', 'yof', '<cmd>setlocal <C-R>=(&formatoptions =~# "a") ? "formatoptions-=a" : "formatoptions+=a"<CR><CR>', {noremap = true})

-- Smarttab
vim.api.nvim_set_keymap('i', '<S-TAB>', '<TAB>', {noremap = true})
vim.api.nvim_set_keymap('i', '<TAB>', '<C-R>=SmartTab()<CR>', {noremap = true, silent = true})

-- Trim trailing whitespace
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>%s/\\s\\+$//<CR>:noh<CR>', {noremap = true})

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
	use 'rhysd/clever-f.vim'
	use 'tpope/vim-repeat'
	use 'tpope/vim-surround'
	use 'tpope/vim-unimpaired'
	use {'terrortylor/nvim-comment', config = 'require("nvim_comment").setup()'}
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
		commit = "80cdb00b221f69348afc4fb4b701f51eb8dd3120",
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
			vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>Telescope live_grep<cr>', {noremap = true})
		end
	}

	---- Completion
	use 'neovim/nvim-lspconfig'
end)

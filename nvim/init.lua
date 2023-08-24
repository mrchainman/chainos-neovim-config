-- Packer Setup
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute(
    '!git clone https://github.com/wbthomason/packer.nvim ' .. install_path
  )
end

vim.cmd [[
augroup Packer
  autocmd!
  autocmd BufWritePost init.lua PackerCompile
augroup end
]]

-- Plugins
require("packer").startup(function()
  -- pcker
  use 'wbthomason/packer.nvim'
  -- dashboard
  use {'glepnir/dashboard-nvim'}
  -- minimap
  -- use {
  -- 'wfxr/minimap.vim',
  -- config = function()
  --   vim.g.minimap_width = 10
  --   vim.g.minimap_auto_start = 0
  --   vim.g.minimap_auto_start_win_enter = 0
  -- end
  -- }
  -- bracket autocompletion
  use "numToStr/FTerm.nvim"
  use 'vim-scripts/auto-pairs-gentle'
  use { "catppuccin/nvim", as = "catppuccin" }
  -- Fancier statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons',
      'arkav/lualine-lsp-progress',
    },
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use { "nvim-telescope/telescope-file-browser.nvim" }
  use {
    'neovim/nvim-lspconfig'
  }
  use {'machakann/vim-sandwich'}
  use {'tpope/vim-commentary'}
  use { 'lewis6991/gitsigns.nvim'}
  use { 'NeogitOrg/neogit', requires = 'nvim-lua/plenary.nvim' }
  use "sindrets/diffview.nvim" 
  -- use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    -- require("toggleterm").setup()
  -- end}
  use {'tmhedberg/SimpylFold'}
  use {
	"lukas-reineke/indent-blankline.nvim",
  	requires = {"nvim-treesitter/nvim-treesitter"}
}
  use {'ap/vim-css-color'}
end)

-- Dashboard
local home = os.getenv('HOME')
local db = require('dashboard')
-- linux
db.preview_command = 'ueberzug'
--
db.preview_file_path = home .. '/.config/wallpaper'
db.preview_file_height = 10
db.preview_file_width = 50
db.center_pad = 5
db.custom_center = {
    {icon = '  ',
    desc = 'New File                                ',
    action =  'DashboardNewFile',
    shortcut = '; f n'},
    {icon = '  ',
    desc = 'Find  File                              ',
    action = 'Telescope find_files find_command=rg,--hidden,--files',
    shortcut = '; f f'},
    {icon = '  ',
    desc = 'File Browser                            ',
    action =  ':Telescope file_browser',
    shortcut = '; f b'},
    {icon = '  ',
    desc = 'Find  word                              ',
    action = 'Telescope live_grep',
    shortcut = '; f w'},
  }

-- Theming
vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
require("catppuccin").setup({transparent_background = true})
vim.cmd [[colorscheme catppuccin]]
-- Neovim configuration
-- Leader key 
vim.g.mapleader = ";"
-- Do not show current vim mode since it is already shown by Lualine
vim.o.showmode = false
-- enable autowriteall
vim.o.autowriteall = true
-- Mouse support
vim.cmd [[ set autochdir ]]
vim.cmd [[ set mouse=a ]]
vim.cmd [[ set go=a ]]
vim.cmd [[ set clipboard+=unnamedplus ]]
vim.cmd [[ set splitbelow splitright ]]
-- Not used but can be enabled
-- vim.cmd [[ set autochdir ]]
vim.cmd [[ set viminfo=%,<800,'10,/50,:100,h,f0,n~/.cache/viminfo ]]
vim.cmd [[ set nocompatible ]]
-- Show the line numbers
vim.wo.number = true
-- Show chars at the end of line
vim.opt.list = true
-- Enable break indent
vim.o.breakindent = true
--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Decrease update time
vim.o.updatetime = 250
-- Enable termguicolors. Very essential if you want 24-bit RGB color in TUI.
vim.o.termguicolors = true
-- vifm with ueberzug
vim.cmd [[ let g:vifm_exec = expand('/usr/bin/vifmrun') ]]
-- Keymaps
local function map(m, k, v)
  vim.keymap.set(m, k, v, {silent = true })
end

-- Navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
map('n', '<leader>H', ':cd %:h<CR>')
map('n', '<leader><leader>', ':quit<CR>')
map('n', '<leader>m', ':MinimapToggle<CR>')

vim.cmd [[tnoremap <C-t> <Cmd>lua require'FTerm'.toggle()<CR>]] 
vim.cmd [[nnoremap <C-t> <Cmd>lua require'FTerm'.toggle()<CR>]]
-- map('t', '<C-t>', ':FTermToggle<CR>')
-- Build Docker
--
vim.api.nvim_create_user_command('Compile', function()
    require('FTerm').run({'chainos-compiler', vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())})
end, { bang = true })


map ('n', '<leader>c', ':Compile<CR>')
map ('n', '<leader>dB', ':TermExec cmd="docker build --no-cache -f % -t "')

-- Docker Compose
map('n', '<leader>dcu', ':TermExec cmd="docker-compose -f % up -d<CR>"')
map('n', '<leader>dcd', ':TermExec cmd="docker-compose -f % down <CR>"')
map('n', '<leader>dcsa', ':TermExec cmd="docker-compose -f % start <CR>"')
map('n', '<leader>dcso', ':TermExec cmd="docker-compose -f % stop <CR>"')
map('n', '<leader>dcb', ':TermExec cmd="docker-compose -f % build <CR>"')
map('n', '<leader>dcB', ':TermExec cmd="docker-compose -f % build --no-cache <CR>"')

-- Dashboard
map('n', '<leader>fn', ':DashboardNewFile<CR>')
map('n', '<leader>ff', ':Telescope find_files find_command=rg,--hidden,--files<CR>')
map('n', '<leader>fb', ':Telescope file_browser<CR>')
map('n', '<leader>fw', ':Telescope live_grep<CR>')

-- Utils
map('n', '<leader>tc', ':tabnew<CR>')
map('n', '<leader>tn', ':tabnext<CR>')
map('n', '<leader>tp', ':tabprevious<CR>')
map('n', '<leader>b', ':buffer')

map('n', '<leader>v', ':source ~/.config/nvim/init.lua<CR>')
map('n', '<leader>e', ':edit ~/.config/nvim/init.lua<CR>')

-- Latex
map('n', '<leader>o', ':!openfile %<CR>')
-- map('n', '<leader><leader>', '/<++><CR>ca<')

-- autopairs
vim.g.AutoPairs = {
  ['(']=')',
  ['[']=']',
  ['{']='}',
  ["'"]="'",
  ['"']='"',
  ['`']='`',
  ['<']='>',
}

-- lualine
require('lualine').setup({
  sections = {
    lualine_c = {
      {'filename', path = 1},
      'lsp_progress',
    },
  },
})


-- require("toggleterm").setup{
--   open_mapping = [[<c-t>]],
--   terminal_mappings = true, 
--   size = 20,
--   direction = 'horizontal',
-- }

require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = true,
}

require("telescope").load_extension "file_browser"

local neogit = require('neogit')
neogit.setup {}

require('gitsigns').setup{
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
-- Extra Git stuff
map('n', '<leader>ga', ':!git add %<CR>')
map('n', '<leader>gc', ':Neogit commit<CR>')
map('n', '<leader>gp', ':!git push <CR>')
map('n', '<leader>N', ':Neogit kind=split_above<CR>')
-- LSP
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-i>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require'lspconfig'.awk_ls.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.dockerls.setup{}
require'lspconfig'.phpactor.setup{}
-- require('lspconfig').yamlls.setup {}
require'lspconfig'.jsonls.setup{}
if vim.g.neovide then
	vim.o.guifont = "Source Code Pro:h14"
	vim.opt.linespace = 0
	vim.g.neovide_scale_factor = 1.0
	vim.g.neovide_padding_top = 15
	vim.g.neovide_padding_bottom = 15
	vim.g.neovide_padding_right = 15
	vim.g.neovide_padding_left = 15
	-- Helper function for transparency formatting
	local alpha = function()
	  return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
	end
	-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
	vim.g.neovide_transparency = 0.0
	vim.g.transparency = 0.8
	vim.g.neovide_background_color = "#0f1117" .. alpha()
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	vim.g.neovide_transparency = 0.8
end




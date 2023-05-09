-- Basics
vim.opt.compatible = false -- explicitly get out of vi-compatible mode
vim.opt.background = "dark"
vim.opt.encoding = "utf-8"

-- General
vim.g.loaded_netrw = 1 -- disable netrw
vim.g.loaded_netrwPlugin = 1 -- disable netrw
vim.opt.autowrite = true
vim.opt.backspace = "indent,eol,start" -- make backspace a little more flexible
vim.opt.clipboard = "unnamedplus" -- share windows clipboard
vim.opt.colorcolumn = {80}
vim.opt.errorbells = false -- don't make noise
vim.opt.hidden = true
vim.opt.history = 50 -- keep 50 lines of command line history
vim.opt.list = true
vim.opt.mouse = "a" -- use mouse everywhere
vim.opt.title = true
vim.opt.whichwrap = "b,s,h,l,<,>,~,[,]" -- everything wraps
vim.opt.wildignore = "*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,*.swp,*.jpg,*.gif,*.png" -- ignore these
vim.opt.wildmenu = true -- turn on command line completion
vim.opt.wildmode = {"longest", "list"} -- turn on wild menu with very large list

-- Vim UI
vim.opt.guifont = "Hack Nerd Font:h10"
vim.opt.cursorline = true -- highlight current line
vim.opt.incsearch = true -- BUT do highlight as you type you search phrase
vim.opt.laststatus = 2 -- always show the status line"
vim.opt.linespace = -2 -- So we can have nice vertical window separators
vim.opt.startofline = false -- leave my cursor where it was
vim.opt.visualbell = false -- don't blink
vim.opt.number = true -- turn on line numbers
vim.opt.ruler = true -- Always show current positions along the bottom
vim.opt.scrolloff = 10 -- Keep 10 lines (top/bottom) for scope"
vim.opt.shortmess = "atI" -- shortens messages to avoid 'press a key' prompt
vim.opt.showcmd = true -- show the command being typed
vim.opt.showmatch = true -- show matching brackets
vim.opt.sidescrolloff = 10 -- Keep 10 lines at the size

-- Text Formatting/Layout
vim.opt.wrap = true -- wrap line
vim.opt.shiftround = true -- when at 3 spaces, and I hit > ... go to 4, not 5
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

--
-- Autocommands
--

-- Remove trailing spaces at save
vim.api.nvim_create_autocmd(
    {"BufWritePre"},
    {
        pattern = { "*" },
        callback = function(ev)
            save_cursor = vim.fn.getpos(".")
            vim.cmd([[%s/\s\+$//e]])
            vim.fn.setpos(".", save_cursor)
        end,
    }
)

--
-- Mappings
--

function noremap(shortcut, command)
    vim.api.nvim_set_keymap("", shortcut, command, {noremap = true})
end

-- [HJKL] -> {CTSR}
noremap("c", "h") -- left
noremap("r", "l") -- right
noremap("t", "j") -- down
noremap("s", "k") -- up
noremap("C", "H") -- top of screen
noremap("R", "L") -- bottom of screen
noremap("T", "J") -- join
noremap("S", "K") -- help
noremap("zs", "zj") -- previous fold
noremap("zt", "zk") -- next fold

-- {HJKL} <- [CTSR]
noremap("j", "t") -- move to
noremap("J", "T") -- move to
noremap("l", "c") -- change
noremap("L", "C") -- change
noremap("h", "r") -- replace
noremap("H", "R") -- replace
noremap("k", "s") -- substitute
noremap("K", "S") -- substitute
noremap("]k", "]s") -- spelling
noremap("[k", "[s") -- spelling

-- Direct < and >
noremap("«", "<")
noremap("»", ">")

-- Easier command access
noremap(":", ".")
noremap(".", ":")

-- Easier $
noremap("ç", "$")

-- Shortcuts
noremap("<F7>", ":make<CR>")
noremap("<F11>", ":A<CR>")

--
-- Plugins
--

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

require("lazy").setup({
    "bfrg/vim-cpp-modern",
    "itchyny/lightline.vim",
    "junegunn/vim-easy-align",
    "lukas-reineke/indent-blankline.nvim",
    "navarasu/onedark.nvim",
    "nvim-lualine/lualine.nvim",
    "nvim-tree/nvim-tree.lua",
    "nvim-tree/nvim-web-devicons",
    "vim-scripts/a.vim",
    {'nvim-telescope/telescope.nvim', dependencies = {'nvim-lua/plenary.nvim'}},
})

-- alternate
vim.g.alternateExtensions_h = "cpp"
vim.g.alternateExtensions_hpp = "cpp"
vim.g.alternateExtensions_cpp = "hpp,h"

-- indent-blankline
require("indent_blankline").setup {
    show_end_of_line = false,
    space_char_blankline = " ",
}

-- lualine
require("lualine").setup{
    options = {
        globalstatus = true,
    },
}

-- easy-align
vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", {}) -- Start interactive EasyAlign in visual mode (e.g. vipga)
vim.api.nvim_set_keymap("n", "ga", "<Plug>(EasyAlign)", {}) -- Start interactive EasyAlign for a motion/text object (e.g. gaip)

-- nvim-tree
local function my_on_attach(bufnr)
    local api = require('nvim-tree.api')

    api.config.mappings.default_on_attach(bufnr)

    -- Delete 's' mapping because I use it as 'up'
    vim.keymap.del('n', 's', { buffer = bufnr })
end
require("nvim-tree").setup({
    on_attach = my_on_attach,
})

-- onedark
require('onedark').load()

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

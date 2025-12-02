-- Leader (using space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.syntax = "on"  -- Enable syntax highlighting
vim.opt.filetype.plugin = "on"  -- Enable filetype plugins
vim.opt.filetype.indent = "on"  -- Enable filetype indentation

-- Enable true colors if available
vim.opt.termguicolors = true

-- Better colorscheme (optional - default is fine)
vim.cmd('colorscheme desert')  -- or 'default', 'industry', 'elflord', 'koehler'

-- OSC52 Clipboard
local function osc52_copy(text)
    if text == nil or text == '' then
        return
    end
    local encoded = vim.fn.system('base64', text)
    encoded = encoded:gsub('\n', '')
    local osc52 = string.char(27) .. "]52;c;" .. encoded .. string.char(7)
    io.stdout:write(osc52)
    io.stdout:flush()
end

-- Clipboard mappings
vim.keymap.set('v', '<leader>c', function()
    vim.cmd('normal! y')
    local text = vim.fn.getreg('"')
    osc52_copy(text)
end, { silent = true, desc = "Copy selection to remote clipboard" })

vim.keymap.set('n', '<leader>c', function()
    vim.cmd('normal! yy')
    local text = vim.fn.getreg('"')
    osc52_copy(text)
end, { silent = true, desc = "Copy line to remote clipboard" })

-- Filetree
local function toggle_filetree()
    local win_count = vim.fn.winnr('$')
    for i = 1, win_count do
        local buf = vim.fn.winbufnr(i)
        if vim.api.nvim_buf_get_option(buf, 'filetype') == 'netrw' then
            vim.cmd(i .. 'wincmd w')
            vim.cmd('close')
            return
        end
    end
    vim.cmd('leftabove vnew | vertical resize 30 | edit .')
end

-- Terminal
local function toggle_terminal()
    local found = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
            vim.api.nvim_win_close(win, true)
            found = true
        end
    end
    if not found then
        vim.cmd('botright split | resize 15 | terminal')
        vim.cmd('wincmd p')
    end
end

-- Keymaps
vim.keymap.set('n', '<leader>e', toggle_filetree, { desc = "Toggle file explorer" })
vim.keymap.set('n', '<leader>t', toggle_terminal, { desc = "Toggle terminal" })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = "Exit terminal mode" }) -- Add this!

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Search improvements
vim.opt.ignorecase = true  -- Ignore case when searching
vim.opt.smartcase = true   -- Unless you type a capital letter
vim.opt.hlsearch = true    -- Highlight search results
vim.opt.incsearch = true   -- Show matches as you type

-- Clear search highlights with <leader>/
vim.keymap.set('n', '<leader>/', ':nohlsearch<CR>', { desc = "Clear search highlights" })

-- Line wrapping
vim.opt.wrap = false  -- Don't wrap lines by default

-- Tab settings
vim.opt.tabstop = 4      -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4   -- Number of spaces for autoindent
vim.opt.expandtab = true -- Use spaces instead of tabs

-- Enable mouse support (optional)
vim.opt.mouse = 'a'

-- Show cursor line
vim.opt.cursorline = true

-- Status line
vim.opt.laststatus = 2  -- Always show status line
vim.opt.statusline = '%f %m %= %l:%c'  -- Simple status line
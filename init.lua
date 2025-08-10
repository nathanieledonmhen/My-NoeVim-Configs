-- ============================================
-- BASIC EDITOR SETTINGS
-- ============================================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.encoding = "utf-8"
vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

-- ============================================
-- AUTOCOMPLETE BRACKETS & QUOTES
-- ============================================
local pairs = {
    { "(", ")" },
    { "[", "]" },
    { "{", "}" },
    { "'", "'" },
    { '"', '"' },
}
for _, p in ipairs(pairs) do
    vim.keymap.set("i", p[1], p[1] .. p[2] .. "<Left>", { noremap = true })
end

-- ============================================
-- PLUGINS
-- ============================================
vim.cmd [[packadd packer.nvim]]
require("packer").startup(function(use)
    use 'rebelot/kanagawa.nvim'
    use {'neoclide/coc.nvim', branch = 'release'}
    use 'honza/vim-snippets'
    use 'neoclide/coc-snippets'
end)

-- ============================================
-- THEME
-- ============================================
vim.cmd.colorscheme("kanagawa-dragon")

-- ============================================
-- RUN PYTHON: <Space> + r
-- ============================================
vim.keymap.set("n", "<SPACE>r", ":w<CR>:!python3 %<CR>", { noremap = true, silent = true })

-- ============================================
-- AUTOCOMPLETE + SNIPPETS
-- ============================================
vim.keymap.set("i", "<CR>", 'pumvisible() ? coc#_select_confirm() : "\\<CR>"', { expr = true, silent = true })
vim.g.coc_global_extensions = {
    'coc-pyright',  -- Python
    'coc-snippets',
    'coc-clangd',   -- C/C++
    'coc-go',       -- Go
    'coc-json',
    'coc-yaml',
    'coc-sh',       -- Shell/Bash
    'coc-html',
    'coc-css',
    'coc-tsserver', -- JavaScript/TypeScript
    'coc-rust-analyzer', -- Rust (common in security tooling)
}

vim.keymap.set("i", "<Space>", 'coc#pum#visible() ? coc#pum#confirm() : coc#expandable() ? "\\<Plug>(coc-snippets-expand)" : "\\<Space>"', { expr = true, silent = true })
vim.keymap.set("i", "<C-l>", "<Plug>(coc-snippets-expand-jump)", { silent = true })
vim.keymap.set("i", "<C-h>", "<Plug>(coc-snippets-prev)", { silent = true })
vim.keymap.set("i", "<C-n>", 'coc#pum#visible() ? coc#pum#next(1) : "\\<C-n>"', { expr = true, silent = true })
vim.keymap.set("i", "<C-p>", 'coc#pum#visible() ? coc#pum#prev(1) : "\\<C-p>"', { expr = true, silent = true })

-- ============================================
-- SYSTEM CLIPBOARD (PC VERSION)
-- ============================================
-- Works on Windows, macOS, Linux with +clipboard support
vim.opt.clipboard = "unnamedplus"

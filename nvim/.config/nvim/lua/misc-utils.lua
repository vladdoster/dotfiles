local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then
        scopes['o'][key] = value
    end
end

opt('o', 'cmdheight', 2)
opt('o', 'hidden', true)
opt('o', 'ignorecase', true)
opt('o', 'numberwidth', 2)
opt('o', 'splitbelow', true)
opt('o', 'splitright', true)
opt('o', 'termguicolors', true)
opt('o', 'timeoutlen', 500)
opt('o', 'updatetime', 250) -- update interval for gitsigns
opt('w', 'cul', true)
opt('w', 'number', true)
opt('w', 'signcolumn', 'yes')
opt('w', 'wrap', false)

-- for indentline
opt('b', 'expandtab', true)
opt('b', 'shiftwidth', 2)

local M = {}

function M.is_buffer_empty()
    return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

function M.window_width_gt(cols)
    -- Check if the windows width is greater than a given number of columns
    return vim.fn.winwidth(0) / 2 > cols
end
-- file extension specific tabbing
vim.cmd([[autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4]])
return M

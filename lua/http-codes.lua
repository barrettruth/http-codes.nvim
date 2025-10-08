local M = {}

local open_url = require('http-codes.os').get_open_url()

M.config = {
    use = nil,
    open_url = open_url,
}

M.http_codes = function()
    if M.config.use == 'telescope' then
        require('telescope').extensions.http.list(M.config.open_url)
    elseif M.config.use == 'fzf-lua' then
        require('http-codes.fzf-lua').pick(M.config.open_url)
    elseif M.config.use == 'snacks' then
        require('http-codes.snacks').pick(M.config.open_url)
    end
end

M.setup = function(user_config)
    if pcall(require, 'fzf-lua') then
        M.config.use = 'fzf-lua'
    elseif pcall(require, 'snacks') then
        M.config.use = 'snacks'
    elseif pcall(require, 'telescope') then
        M.config.use = 'telescope'
    end

    if M.config.use == nil then
        vim.notify_once 'http-codes.nvim: install fzf-lua or snakcs.nvim or telescope.nvim'
        return
    end

    if user_config.use then M.config.use = user_config.use end

    if
        not vim.tbl_contains({ 'fzf-lua', 'snacks', 'telescope' }, M.config.use)
    then
        vim.notify_once(
            'http-codes.nvim: must specify `use = {fzf-lua,snacks,telescope}` in setup.',
            vim.log.levels.ERROR
        )
        return
    end

    M.config = vim.tbl_deep_extend('force', M.config, user_config)

    if M.config.use == 'telescope' then
        require('http-codes.telescope').setup()
    end

    vim.api.nvim_create_user_command('HTTPCodes', M.http_codes, {})
end

return M

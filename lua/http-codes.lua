local M = {}

local initialized = false

local defaults = {
  use = nil,
  open_url = nil,
}

local config = vim.deepcopy(defaults)

local function init()
  if initialized then
    return true
  end

  local user_config = vim.g.http_codes or {}
  config = vim.tbl_deep_extend('force', defaults, user_config)

  if not config.open_url then
    config.open_url = require('http-codes.os').get_open_url()
  end

  if not config.use then
    if pcall(require, 'fzf-lua') then
      config.use = 'fzf-lua'
    elseif pcall(require, 'snacks') then
      config.use = 'snacks'
    elseif pcall(require, 'telescope') then
      config.use = 'telescope'
    end
  end

  if not config.use then
    vim.notify_once('http-codes.nvim: install fzf-lua, snacks.nvim, or telescope.nvim', vim.log.levels.ERROR)
    return false
  end

  if not vim.tbl_contains({ 'fzf-lua', 'snacks', 'telescope' }, config.use) then
    vim.notify_once(
      "http-codes.nvim: 'use' must be 'fzf-lua', 'snacks', or 'telescope'",
      vim.log.levels.ERROR
    )
    return false
  end

  if config.use == 'telescope' then
    require('http-codes.telescope').setup()
  end

  initialized = true
  return true
end

function M.pick()
  if not init() then
    return
  end

  if config.use == 'telescope' then
    require('telescope').extensions.http.list(config.open_url)
  elseif config.use == 'fzf-lua' then
    require('http-codes.fzf-lua').pick(config.open_url)
  elseif config.use == 'snacks' then
    require('http-codes.snacks').pick(config.open_url)
  end
end

M.http_codes = M.pick

---@deprecated Use `vim.g.http_codes` instead
function M.setup(user_config)
  vim.notify_once(
    'http-codes.nvim: setup() is deprecated. Use vim.g.http_codes instead.',
    vim.log.levels.WARN
  )

  if user_config then
    vim.g.http_codes = vim.tbl_deep_extend('force', vim.g.http_codes or {}, user_config)
  end

  init()
end

return M

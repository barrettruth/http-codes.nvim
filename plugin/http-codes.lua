if vim.g.loaded_http_codes then
  return
end
vim.g.loaded_http_codes = 1

vim.api.nvim_create_user_command('HTTPCodes', function()
  require('http-codes').pick()
end, {})

vim.keymap.set('n', '<Plug>(http-codes-pick)', function()
  require('http-codes').pick()
end, { desc = 'Pick HTTP status code' })

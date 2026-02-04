local codes = require('http-codes.codes')
local cached_items = nil

local function codes_to_snack_items(codes_map)
  if cached_items then
    return cached_items
  end

  local items = {}

  local idx = 1
  for status, _ in pairs(codes_map) do
    table.insert(items, { idx = idx, text = status })
    idx = idx + 1
  end
  cached_items = items
  return items
end

return {
  pick = function(open_url)
    require('snacks.picker').pick(nil, {
      title = 'HTTP Codes',
      items = codes_to_snack_items(codes),
      format = 'text',
      layout = {
        preset = 'select',
        hidden = { 'preview' },
      },
      confirm = function(picker, item)
        local link = codes[item.text]
        picker:close()
        vim.fn.jobstart(open_url:format(link))
      end,
    })
  end,
}

local list = require('telescope._extensions.http.list')

return require('telescope').register_extension({
  exports = { list = list },
})

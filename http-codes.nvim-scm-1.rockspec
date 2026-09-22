rockspec_format = '3.0'
package = 'http-codes.nvim'
version = 'scm-1'

source = { url = 'git+https://forge.barrettruth.com/barrettruth/http-codes.nvim.git' }

description = {
  license = 'GPL-3.0',
}

build = { type = 'builtin' }

test_dependencies = {
  'lua >= 5.1',
  'nlua',
  'busted >= 2.1.1',
}

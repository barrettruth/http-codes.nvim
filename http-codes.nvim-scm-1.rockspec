rockspec_format = '3.0'
package = 'http-codes.nvim'
version = 'scm-1'

source = { url = 'git+https://git.barrettruth.com/barrettruth/http-codes.nvim.git' }
build = { type = 'builtin' }

test_dependencies = {
  'lua >= 5.1',
  'nlua',
  'busted >= 2.1.1',
}

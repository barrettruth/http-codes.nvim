rockspec_format = '3.0'
package = 'http-codes.nvim'
version = 'scm-1'

source = { url = 'git://github.com/barrettruth/http-codes.nvim' }
build = { type = 'builtin' }

test_dependencies = {
  'lua >= 5.1',
  'nlua',
  'busted >= 2.1.1',
}

# http-codes.nvim

Quickly investigate HTTP status codes with the help of [mozilla](https://developer.mozilla.org/en-US/docs/Web/HTTP), including [telescope](https://github.com/barrett-ruth/telescope-http.nvim/), [fzf-lua](https://github.com/ibhagwan/fzf-lua) and [snacks.nvim](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md) integrations.

## Installation

Install via your favorite package manager, like [lazy](https://github.com/folke/lazy.nvim):

```lua
require('lazy').setup({
    {
        'barrett-ruth/http-codes.nvim',
        config = true,
        -- or 'nvim-telescope/telescope.nvim'
        -- or 'folke/snacks.nvim'
        dependencies = 'ibhagwan/fzf-lua'
        keys = { { '<leader>H', '<cmd>HTTPCodes<cr>' }}
    }
})
```

## [Configuration](./doc/http-codes.txt)

`http-codes.nvim` uses telescope or fzf-lua (whichever you've installed), which can be manually overidden.

`http-codes.nvim` opens the Mozilla documentation URLs based on your operating system. This can be overidden.

| OS      | open_url      |
| ------- | ------------- |
| Windows | `start %s`    |
| OSX     | `open %s`     |
| UNIX    | `xdg-open %s` |

See [the docs](./doc/http-codes.txt) for more information.

## Usage

Use the exposed command in vimscript:

```lua
:HTTPCodes
```

or in lua:

```lua
require('http-codes').http_codes()
```

## Migration

If migrating from [telescope-http.nvim](https://github.com/barrett-ruth/telescope-http.nvim), follow the above instructions&mdash;no telescope-specific config is necessary.

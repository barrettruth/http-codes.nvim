# http-codes.nvim

Quickly investigate HTTP status codes with [Mozilla](https://developer.mozilla.org/en-US/docs/Web/HTTP), with telescope, fzf-lua, and snacks.nvim integrations.

> [!NOTE]
> Due to GitHub's historic unreliability, active development is hosted on
> [Forgejo](https://git.barrettruth.com/barrettruth/http-codes.nvim).
> GitHub is maintained as a read-only mirror.
> See `:help http-codes-forgejo` for canonical project links.

## Installation

With `vim.pack` (Neovim 0.12+):

```lua
vim.pack.add({
  'https://git.barrettruth.com/barrettruth/http-codes.nvim',
})
```

Or via [luarocks](https://luarocks.org/modules/barrettruth/http-codes.nvim):

```
luarocks install http-codes.nvim
```

## Dependencies

One of:

- [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- [snacks.nvim](https://github.com/folke/snacks.nvim)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Quick Start

Install one picker backend first, then http-codes.nvim so the command has a UI to open.

```lua
vim.pack.add({
  'https://github.com/ibhagwan/fzf-lua',
  'https://git.barrettruth.com/barrettruth/http-codes.nvim',
})
```

Set the backend before http-codes.nvim loads if you want deterministic picker selection.

```lua
vim.g.http_codes = {
  use = 'fzf-lua',
}
```

Open the picker when you need to inspect a response code; type `404`, `429`, or `500`, then press `<CR>` to open the selected MDN page.

```vim
:HTTPCodes
```

Bind the `<Plug>` mapping if you look up status codes often.

```lua
vim.keymap.set('n', '<leader>hc', '<Plug>(http-codes-pick)')
```

## Documentation

```vim
:help http-codes
```

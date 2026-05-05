# http-codes.nvim

Quickly investigate HTTP status codes with [Mozilla](https://developer.mozilla.org/en-US/docs/Web/HTTP), with telescope, fzf-lua, and snacks.nvim integrations.

> [!NOTE]
> Due to GitHub's historic unreliability, active development is hosted on
> [Forgejo](https://git.barrettruth.com/barrettruth/http-codes.nvim).
> GitHub is maintained as a read-only mirror.
> See `:help http-codes.nvim-forgejo` for canonical project links.

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

## Documentation

```vim
:help http-codes.nvim
```

# http-codes.nvim

Quickly investigate HTTP status codes with the help of [Mozilla](https://developer.mozilla.org/en-US/docs/Web/HTTP), with telescope and fzf-lua integrations.

## Installation

Install using your package manager of choice or via [luarocks](https://luarocks.org/modules/barrettruth/http-codes.nvim):

```
luarocks install http-codes.nvim
```

## Dependencies

One of:
- [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Configuration

Configure via `vim.g.http_codes` before the plugin loads:

```lua
vim.g.http_codes = {
  use = 'fzf-lua', -- or 'telescope', auto-detected by default
  open_url = 'xdg-open %s', -- OS-specific by default
}
```

| OS      | Default open_url |
| ------- | ---------------- |
| Windows | `start %s`       |
| macOS   | `open %s`        |
| Linux   | `xdg-open %s`    |

## Usage

```vim
:HTTPCodes
```

## Documentation

```vim
:help http-codes.nvim
```

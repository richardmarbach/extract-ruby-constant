# extract-ruby-constant

Extract the the ruby constant under the cursor and place it in the yank register.

## Requirements

- `neovim >= 0.8`
- `treesitter`

## Installation

### Packer

`use { 'richardmarbach/extract-ruby-constant' }`

### Vim-Plug

`Plug 'richardmarbach/extract-ruby-constant'`

## Usage

`:lua require('extract-ruby-constant').extract()`

`:lua require('extract-ruby-constant').yank()`

```lua
vim.keymap.set("o", "<leader>oc", require("extract-ruby-constant").extract)
vim.keymap.set("n", "<leader>oc", require("extract-ruby-constant").yank)
```

# Deux

A soft, warm pastel color scheme for Neovim — generated from [`deux.yaml`](./deux.yaml).

Two themes, switched by `background`:

- **Linen** — light (`set background=light`)
- **Embers** — dark (`set background=dark`)

## Requirements

- Neovim ≥ 0.8 with `termguicolors` (a true-color terminal).

## Install

**lazy.nvim**

```lua
{
  "deux",                 -- or "<you>/deux" once published
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("deux")
  end,
}
```

**packer.nvim**

```lua
use("deux")
```

**Manual** — copy this repo into a directory on your `runtimepath`
(e.g. `~/.config/nvim/pack/themes/start/deux`).

## Usage

```vim
set background=dark   " Embers, or 'light' for Linen
colorscheme deux
```

## Configuration

`setup()` is optional — it only overrides defaults.

```lua
require("deux").setup({
  variant  = "auto",  -- "auto" (follow background) | "light" | "dark"
  terminal = true,    -- set g:terminal_color_* to match
})
vim.cmd.colorscheme("deux")
```

## tmux

Theme files live in [`tmux/`](./tmux). Source one from your `~/.tmux.conf`:

```tmux
# Embers (dark)
source-file ~/path/to/deux/tmux/deux-dark.conf

# …or Linen (light)
source-file ~/path/to/deux/tmux/deux-light.conf
```

Reload with `tmux source-file ~/.tmux.conf` (or `prefix` + `:source-file …`).
Requires tmux ≥ 3.2 (uses `%hidden` parse variables and `#{d:current_file}`)
and a true-color terminal.

The two entry files only define the palette, then both source the shared
`deux-common.conf`, which styles the status bar, windows, panes, copy mode,
messages, and clock.

## Layout

```
colors/deux.lua          -- :colorscheme entry point
lua/deux/init.lua        -- load(), setup(), terminal colors
lua/deux/palette.lua     -- raw colors from deux.yaml + resolved aliases
lua/deux/highlights.lua  -- editor, Treesitter, LSP, diagnostic, plugin groups
tmux/deux-dark.conf      -- Embers palette  -> deux-common.conf
tmux/deux-light.conf     -- Linen palette   -> deux-common.conf
tmux/deux-common.conf    -- shared status / pane / mode styling
```

To change a color, edit `deux.yaml` and mirror it in `lua/deux/palette.lua`.

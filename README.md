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

Requires tmux ≥ 3.2 (uses `%hidden` parse variables and `#{d:current_file}`)
and a true-color terminal.

**TPM** ([Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)) — add to
your `~/.tmux.conf`:

```tmux
set -g @plugin 'deux'              # or '<you>/deux' once published

# Optional — pick the variant (default: dark):
set -g @deux-variant 'dark'       # 'dark' (Embers) | 'light' (Linen)

run '~/.tmux/plugins/tpm/tpm'     # keep this line last
```

Then hit `prefix` + <kbd>I</kbd> to install. The plugin's `deux.tmux` entry
script sources the chosen variant for you.

**Manual** — source a variant directly from your `~/.tmux.conf`:

```tmux
# Embers (dark)
source-file ~/path/to/deux/tmux/deux-dark.conf

# …or Linen (light)
source-file ~/path/to/deux/tmux/deux-light.conf
```

Reload with `tmux source-file ~/.tmux.conf` (or `prefix` + `:source-file …`).

The two entry files only define the palette, then both source the shared
`deux-common.conf`, which styles the status bar, windows, panes, copy mode,
messages, and clock.

## Alacritty

Theme files live in [`alacritty/`](./alacritty). Import one from your
`alacritty.toml`:

```toml
[general]
import = ["~/path/to/deux/alacritty/deux-dark.toml"]   # or deux-light.toml
```

Requires Alacritty ≥ 0.13 (TOML config) and a true-color terminal.

## Windows Terminal

Color schemes live in [`windows-terminal/`](./windows-terminal). Open Windows
Terminal → **Settings** → **Open JSON file**, then paste the contents of
`deux-dark.json` (*Deux Embers*) and/or `deux-light.json` (*Deux Linen*) as
objects into the top-level `"schemes": [ … ]` array:

```jsonc
"schemes": [
  { "name": "Deux Embers", /* … */ },
  { "name": "Deux Linen",  /* … */ }
]
```

Save, then select the scheme under a profile via **Appearance → Color scheme**
(or set `"colorScheme": "Deux Embers"` in the profile's JSON).

## Note on blue & cyan

Deux is a warm pastel palette with no native blue or cyan. In the terminal
themes (which need a full 16-color ANSI set) the blue and cyan slots are
synthesized to sit at the same softness as the rest of the palette; every
other slot maps to a real `deux.yaml` token, noted inline in each file.

## Layout

```
colors/deux.lua          -- :colorscheme entry point
lua/deux/init.lua        -- load(), setup(), terminal colors
lua/deux/palette.lua     -- raw colors from deux.yaml + resolved aliases
lua/deux/highlights.lua  -- editor, Treesitter, LSP, diagnostic, plugin groups
deux.tmux                -- TPM entry point  -> sources a tmux variant
tmux/deux-dark.conf      -- Embers palette  -> deux-common.conf
tmux/deux-light.conf     -- Linen palette   -> deux-common.conf
tmux/deux-common.conf    -- shared status / pane / mode styling
alacritty/deux-dark.toml      -- Embers · Alacritty colors
alacritty/deux-light.toml     -- Linen  · Alacritty colors
windows-terminal/deux-dark.json   -- Embers · Windows Terminal scheme
windows-terminal/deux-light.json  -- Linen  · Windows Terminal scheme
```

To change a color, edit `deux.yaml` and mirror it in `lua/deux/palette.lua`.

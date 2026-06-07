-- Deux — soft warm pastel color scheme for Neovim
-- Themes: light (Linen) and dark (Embers), selected via `vim.o.background`.

local palette = require("deux.palette")
local highlights = require("deux.highlights")

local M = {}

M.config = {
  -- "auto" follows vim.o.background; or force "light" / "dark".
  variant = "auto",
  -- Apply a matching terminal palette (g:terminal_color_*).
  terminal = true,
}

--- Resolve the effective background name from config + vim state.
local function resolve_background()
  if M.config.variant == "light" or M.config.variant == "dark" then
    return M.config.variant
  end
  return vim.o.background == "light" and "light" or "dark"
end

--- Map the palette onto Neovim's :terminal colors.
local function set_terminal(c)
  vim.g.terminal_color_0  = c.panel
  vim.g.terminal_color_8  = c.line
  vim.g.terminal_color_1  = c.kw
  vim.g.terminal_color_9  = c.kw
  vim.g.terminal_color_2  = c.str
  vim.g.terminal_color_10 = c.str
  vim.g.terminal_color_3  = c.fn
  vim.g.terminal_color_11 = c.fn
  vim.g.terminal_color_4  = c.ty
  vim.g.terminal_color_12 = c.ty
  vim.g.terminal_color_5  = c.const
  vim.g.terminal_color_13 = c.const
  vim.g.terminal_color_6  = c.num
  vim.g.terminal_color_14 = c.num
  vim.g.terminal_color_7  = c.fg
  vim.g.terminal_color_15 = c.fg
end

--- Optional setup to override defaults. Calling it is not required.
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

--- Load and apply the colorscheme.
function M.load()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "deux"

  local background = resolve_background()
  vim.o.background = background

  local c = palette.get(background)
  local groups = highlights.get(c)

  local set_hl = vim.api.nvim_set_hl
  for group, spec in pairs(groups) do
    set_hl(0, group, spec)
  end

  if M.config.terminal then
    set_terminal(c)
  end
end

return M

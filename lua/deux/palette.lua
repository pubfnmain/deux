-- Deux — soft warm pastel color scheme
-- Palettes generated from deux.yaml (light: Linen, dark: Embers)
-- Aliases are resolved here so callers get a flat, ready-to-use table.

local M = {}

M.light = {
  -- surfaces
  bg        = "#f6efe4",
  bg_alt    = "#efe6d6",
  panel     = "#ede2cd",
  line      = "#ddd0b5",
  selection = "#e8d4b0",
  -- text
  fg        = "#4a3a2c",
  fg_muted  = "#8a7a66",
  -- syntax
  kw        = "#b85c7a", -- keyword     — dusty rose
  str       = "#6e8b5a", -- string      — moss
  fn        = "#c08a3e", -- function    — amber
  num       = "#c46a4a", -- number      — terracotta
  ty        = "#8a6fa8", -- type        — lavender
  const     = "#a85a48", -- constant    — clay
  cmt       = "#a89478", -- comment     — faded sand
  op        = "#7a5d4a", -- operator    — warm brown
  -- diagnostics
  error     = "#c44a4a",
  -- diff
  add_bg    = "#dde9c8",
  add_fg    = "#4a6a38",
  del_bg    = "#ecd0c8",
  del_fg    = "#8a3a2c",
}

M.dark = {
  -- surfaces
  bg        = "#1e1c1a",
  bg_alt    = "#272523",
  panel     = "#181614",
  line      = "#45433f",
  selection = "#45433f",
  -- text
  fg        = "#e8dcc8",
  fg_muted  = "#a89478",
  -- syntax
  kw        = "#e89aa8", -- keyword     — blush
  str       = "#b8c89a", -- string      — sage
  fn        = "#e8c078", -- function    — gold
  num       = "#e8a878", -- number      — peach
  ty        = "#c8a8d8", -- type        — lilac
  const     = "#e89878", -- constant    — salmon
  cmt       = "#8a7a66", -- comment     — ash
  op        = "#c8b8a0", -- operator    — warm grey
  -- diagnostics
  error     = "#e89898",
  -- diff
  add_bg    = "#3a4a2e",
  add_fg    = "#c8d8a8",
  del_bg    = "#4a3028",
  del_fg    = "#e8a898",
}

-- Resolve the alias tokens (theme-agnostic references from deux.yaml)
-- into concrete colors for a given theme table.
local function with_aliases(c)
  c.cursor = c.num   -- {syntax.num}
  c.tag    = c.kw    -- {syntax.kw}
  c.attr   = c.fn    -- {syntax.fn}
  c.prop   = c.ty    -- {syntax.ty}
  c.warn   = c.fn    -- {syntax.fn}
  c.info   = c.str   -- {syntax.str}
  c.hint   = c.ty    -- {syntax.ty}
  return c
end

with_aliases(M.light)
with_aliases(M.dark)

--- Return the palette for the requested background ("light" | "dark").
function M.get(background)
  return background == "light" and M.light or M.dark
end

return M

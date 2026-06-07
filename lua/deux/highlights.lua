-- Deux — highlight group definitions.
-- Maps the deux.yaml palette onto Neovim editor, syntax, Treesitter,
-- LSP, diagnostic, and common plugin highlight groups.

local M = {}

--- Build the full highlight table for a resolved palette `c`.
function M.get(c)
  return {
    -- ── Editor UI ──────────────────────────────────────────
    Normal       = { fg = c.fg, bg = c.bg },
    NormalNC     = { fg = c.fg, bg = c.bg },
    NormalFloat  = { fg = c.fg, bg = c.panel },
    FloatBorder  = { fg = c.line, bg = c.panel },
    FloatTitle   = { fg = c.fn, bg = c.panel, bold = true },
    ColorColumn  = { bg = c.bg_alt },
    Cursor       = { fg = c.bg, bg = c.cursor },
    lCursor      = { fg = c.bg, bg = c.cursor },
    CursorLine   = { bg = c.bg_alt },
    CursorColumn = { bg = c.bg_alt },
    CursorLineNr = { fg = c.fn, bold = true },
    LineNr       = { fg = c.fg_muted },
    SignColumn   = { bg = c.bg },
    Folded       = { fg = c.fg_muted, bg = c.bg_alt },
    FoldColumn   = { fg = c.fg_muted, bg = c.bg },
    Conceal      = { fg = c.fg_muted },
    NonText      = { fg = c.line },
    Whitespace   = { fg = c.line },
    EndOfBuffer  = { fg = c.bg },
    Directory    = { fg = c.fn },
    Title        = { fg = c.fn, bold = true },

    Visual       = { bg = c.selection },
    VisualNOS    = { bg = c.selection },
    Search       = { fg = c.bg, bg = c.fn },
    IncSearch    = { fg = c.bg, bg = c.num },
    CurSearch    = { fg = c.bg, bg = c.num },
    MatchParen   = { fg = c.num, bold = true },

    Pmenu        = { fg = c.fg, bg = c.panel },
    PmenuSel     = { fg = c.fg, bg = c.selection },
    PmenuSbar    = { bg = c.panel },
    PmenuThumb   = { bg = c.line },
    WildMenu     = { fg = c.fg, bg = c.selection },

    StatusLine   = { fg = c.fg, bg = c.panel },
    StatusLineNC = { fg = c.fg_muted, bg = c.bg_alt },
    TabLine      = { fg = c.fg_muted, bg = c.bg_alt },
    TabLineFill  = { bg = c.bg_alt },
    TabLineSel   = { fg = c.fg, bg = c.bg, bold = true },
    WinSeparator = { fg = c.line },
    VertSplit    = { fg = c.line },

    ErrorMsg     = { fg = c.error, bold = true },
    WarningMsg   = { fg = c.warn },
    ModeMsg      = { fg = c.fg, bold = true },
    MoreMsg      = { fg = c.str },
    Question     = { fg = c.str },
    MsgArea      = { fg = c.fg },

    SpellBad     = { sp = c.error, undercurl = true },
    SpellCap     = { sp = c.warn, undercurl = true },
    SpellRare    = { sp = c.info, undercurl = true },
    SpellLocal   = { sp = c.hint, undercurl = true },

    -- ── Legacy syntax groups ───────────────────────────────
    Comment        = { fg = c.cmt, italic = true },

    Constant       = { fg = c.const },
    String         = { fg = c.str },
    Character      = { fg = c.str },
    Number         = { fg = c.num },
    Float          = { fg = c.num },
    Boolean        = { fg = c.const },

    Identifier     = { fg = c.fg },
    Function       = { fg = c.fn },

    Statement      = { fg = c.kw },
    Conditional    = { fg = c.kw },
    Repeat         = { fg = c.kw },
    Label          = { fg = c.kw },
    Operator       = { fg = c.op },
    Keyword        = { fg = c.kw },
    Exception      = { fg = c.kw },

    PreProc        = { fg = c.const },
    Include        = { fg = c.kw },
    Define         = { fg = c.const },
    Macro          = { fg = c.const },
    PreCondit      = { fg = c.const },

    Type           = { fg = c.ty },
    StorageClass   = { fg = c.kw },
    Structure      = { fg = c.ty },
    Typedef        = { fg = c.ty },

    Special        = { fg = c.fn },
    SpecialChar    = { fg = c.num },
    Tag            = { fg = c.tag },
    Delimiter      = { fg = c.op },
    SpecialComment = { fg = c.cmt, italic = true },
    Debug          = { fg = c.num },

    Underlined     = { fg = c.fn, underline = true },
    Ignore         = { fg = c.fg_muted },
    Error          = { fg = c.error, bold = true },
    Todo           = { fg = c.bg, bg = c.fn, bold = true },

    -- ── Diagnostics ────────────────────────────────────────
    DiagnosticError = { fg = c.error },
    DiagnosticWarn  = { fg = c.warn },
    DiagnosticInfo  = { fg = c.info },
    DiagnosticHint  = { fg = c.hint },
    DiagnosticOk    = { fg = c.str },

    DiagnosticVirtualTextError = { fg = c.error, bg = c.bg_alt },
    DiagnosticVirtualTextWarn  = { fg = c.warn, bg = c.bg_alt },
    DiagnosticVirtualTextInfo  = { fg = c.info, bg = c.bg_alt },
    DiagnosticVirtualTextHint  = { fg = c.hint, bg = c.bg_alt },

    DiagnosticUnderlineError = { sp = c.error, undercurl = true },
    DiagnosticUnderlineWarn  = { sp = c.warn, undercurl = true },
    DiagnosticUnderlineInfo  = { sp = c.info, undercurl = true },
    DiagnosticUnderlineHint  = { sp = c.hint, undercurl = true },

    -- ── Diff / git ─────────────────────────────────────────
    DiffAdd     = { fg = c.add_fg, bg = c.add_bg },
    DiffDelete  = { fg = c.del_fg, bg = c.del_bg },
    DiffChange  = { bg = c.bg_alt },
    DiffText    = { fg = c.fn, bg = c.selection },

    Added       = { fg = c.add_fg },
    Removed     = { fg = c.del_fg },
    Changed     = { fg = c.fn },

    diffAdded   = { fg = c.add_fg },
    diffRemoved = { fg = c.del_fg },
    diffChanged = { fg = c.fn },
    diffLine    = { fg = c.fg_muted },
    diffFile    = { fg = c.fn },

    GitSignsAdd    = { fg = c.add_fg },
    GitSignsChange = { fg = c.fn },
    GitSignsDelete = { fg = c.del_fg },

    -- ── Treesitter ─────────────────────────────────────────
    ["@comment"]              = { link = "Comment" },
    ["@comment.error"]        = { fg = c.error },
    ["@comment.warning"]      = { fg = c.warn },
    ["@comment.todo"]         = { link = "Todo" },
    ["@comment.note"]         = { fg = c.info },

    ["@constant"]             = { fg = c.const },
    ["@constant.builtin"]     = { fg = c.const },
    ["@constant.macro"]       = { fg = c.const },
    ["@number"]               = { fg = c.num },
    ["@number.float"]         = { fg = c.num },
    ["@boolean"]              = { fg = c.const },
    ["@character"]            = { fg = c.str },
    ["@character.special"]    = { fg = c.num },

    ["@string"]               = { fg = c.str },
    ["@string.regexp"]        = { fg = c.num },
    ["@string.escape"]        = { fg = c.num },
    ["@string.special"]       = { fg = c.fn },
    ["@string.special.url"]   = { fg = c.fn, underline = true },

    ["@variable"]             = { fg = c.fg },
    ["@variable.builtin"]     = { fg = c.const },
    ["@variable.parameter"]   = { fg = c.fg },
    ["@variable.member"]      = { fg = c.prop },

    ["@field"]                = { fg = c.prop },
    ["@property"]             = { fg = c.prop },

    ["@function"]             = { fg = c.fn },
    ["@function.builtin"]     = { fg = c.fn },
    ["@function.call"]        = { fg = c.fn },
    ["@function.macro"]       = { fg = c.fn },
    ["@function.method"]      = { fg = c.fn },
    ["@function.method.call"] = { fg = c.fn },
    ["@constructor"]          = { fg = c.ty },

    ["@keyword"]              = { fg = c.kw },
    ["@keyword.function"]     = { fg = c.kw },
    ["@keyword.operator"]     = { fg = c.kw },
    ["@keyword.return"]       = { fg = c.kw },
    ["@keyword.conditional"]  = { fg = c.kw },
    ["@keyword.repeat"]       = { fg = c.kw },
    ["@keyword.import"]       = { fg = c.kw },
    ["@keyword.exception"]    = { fg = c.kw },
    ["@keyword.directive"]    = { fg = c.const },

    ["@operator"]             = { fg = c.op },

    ["@type"]                 = { fg = c.ty },
    ["@type.builtin"]         = { fg = c.ty },
    ["@type.definition"]      = { fg = c.ty },
    ["@attribute"]            = { fg = c.attr },

    ["@punctuation.delimiter"]   = { fg = c.op },
    ["@punctuation.bracket"]     = { fg = c.op },
    ["@punctuation.special"]     = { fg = c.num },

    ["@tag"]                  = { fg = c.tag },
    ["@tag.builtin"]          = { fg = c.tag },
    ["@tag.attribute"]        = { fg = c.attr },
    ["@tag.delimiter"]        = { fg = c.op },

    ["@label"]                = { fg = c.kw },
    ["@module"]               = { fg = c.ty },
    ["@namespace"]            = { fg = c.ty },

    -- Markup (markdown, etc.)
    ["@markup.heading"]       = { fg = c.fn, bold = true },
    ["@markup.strong"]        = { fg = c.fg, bold = true },
    ["@markup.italic"]        = { fg = c.fg, italic = true },
    ["@markup.strikethrough"] = { fg = c.fg_muted, strikethrough = true },
    ["@markup.link"]          = { fg = c.kw },
    ["@markup.link.url"]      = { fg = c.fn, underline = true },
    ["@markup.link.label"]    = { fg = c.kw },
    ["@markup.raw"]           = { fg = c.str },
    ["@markup.list"]          = { fg = c.op },
    ["@markup.quote"]         = { fg = c.cmt, italic = true },

    -- ── LSP semantic tokens ────────────────────────────────
    ["@lsp.type.class"]         = { fg = c.ty },
    ["@lsp.type.enum"]          = { fg = c.ty },
    ["@lsp.type.interface"]     = { fg = c.ty },
    ["@lsp.type.struct"]        = { fg = c.ty },
    ["@lsp.type.type"]          = { fg = c.ty },
    ["@lsp.type.typeParameter"] = { fg = c.ty },
    ["@lsp.type.namespace"]     = { fg = c.ty },
    ["@lsp.type.function"]      = { fg = c.fn },
    ["@lsp.type.method"]        = { fg = c.fn },
    ["@lsp.type.property"]      = { fg = c.prop },
    ["@lsp.type.parameter"]     = { fg = c.fg },
    ["@lsp.type.variable"]      = { fg = c.fg },
    ["@lsp.type.keyword"]       = { fg = c.kw },
    ["@lsp.type.string"]        = { fg = c.str },
    ["@lsp.type.number"]        = { fg = c.num },
    ["@lsp.type.comment"]       = { fg = c.cmt },
    ["@lsp.type.macro"]         = { fg = c.const },
    ["@lsp.type.decorator"]     = { fg = c.attr },

    LspReferenceText  = { bg = c.bg_alt },
    LspReferenceRead  = { bg = c.bg_alt },
    LspReferenceWrite = { bg = c.selection },
    LspInlayHint      = { fg = c.fg_muted, bg = c.bg_alt },
    LspSignatureActiveParameter = { fg = c.num, bold = true },

    -- ── HTML / CSS (legacy groups, mirror yaml aliases) ────
    htmlTag        = { fg = c.op },
    htmlEndTag     = { fg = c.op },
    htmlTagName    = { fg = c.tag },
    htmlArg        = { fg = c.attr },
    cssProp        = { fg = c.prop },
    cssTagName     = { fg = c.tag },
    cssClassName   = { fg = c.fn },

    -- ── Telescope ──────────────────────────────────────────
    TelescopeNormal        = { fg = c.fg, bg = c.panel },
    TelescopeBorder        = { fg = c.line, bg = c.panel },
    TelescopeSelection     = { fg = c.fg, bg = c.selection },
    TelescopeMatching      = { fg = c.num, bold = true },
    TelescopePromptPrefix  = { fg = c.kw },
    TelescopeTitle         = { fg = c.bg, bg = c.fn, bold = true },

    -- ── nvim-cmp ───────────────────────────────────────────
    CmpItemAbbr           = { fg = c.fg },
    CmpItemAbbrMatch      = { fg = c.num, bold = true },
    CmpItemAbbrDeprecated = { fg = c.fg_muted, strikethrough = true },
    CmpItemKindFunction   = { fg = c.fn },
    CmpItemKindKeyword    = { fg = c.kw },
    CmpItemKindVariable   = { fg = c.fg },
    CmpItemKindClass      = { fg = c.ty },
    CmpItemKindSnippet    = { fg = c.str },

    -- ── nvim-tree / neo-tree ───────────────────────────────
    NvimTreeNormal       = { fg = c.fg, bg = c.panel },
    NvimTreeFolderName   = { fg = c.fn },
    NvimTreeFolderIcon   = { fg = c.fn },
    NvimTreeRootFolder   = { fg = c.kw, bold = true },
    NvimTreeGitDirty     = { fg = c.fn },
    NvimTreeGitNew       = { fg = c.add_fg },
    NvimTreeGitDeleted   = { fg = c.del_fg },
    NeoTreeNormal        = { fg = c.fg, bg = c.panel },
    NeoTreeNormalNC      = { fg = c.fg, bg = c.panel },
    NeoTreeRootName      = { fg = c.kw, bold = true },

    -- ── WhichKey ───────────────────────────────────────────
    WhichKey          = { fg = c.fn },
    WhichKeyGroup     = { fg = c.kw },
    WhichKeyDesc      = { fg = c.fg },
    WhichKeySeparator = { fg = c.fg_muted },
    WhichKeyFloat     = { bg = c.panel },

    -- ── Indent guides ──────────────────────────────────────
    IblIndent = { fg = c.line },
    IblScope  = { fg = c.fg_muted },
  }
end

return M

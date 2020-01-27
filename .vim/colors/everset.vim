if &background !=# 'dark'
  set background=dark
endif

if exists('g:colors_name')
  hi clear
endif

if exists('g:syntax_on')
  syntax reset
endif

let g:colors_name = "everset"

" --------------------------------
" Editor settings
" --------------------------------
hi Normal guifg=#a8cfe9 guibg=#0e192c gui=none
hi Cursor guifg=none guibg=#fa9474 gui=none
hi CursorLine guifg=none guibg=#051022 gui=none
hi LineNr guifg=#8086a8 guibg=none gui=none
hi CursorLineNR guifg=#d6d9ec guibg=none gui=none

" -----------------
" - Number column -
" -----------------
hi CursorColumn    guifg=none    guibg=#051022    gui=none
hi FoldColumn      guifg=none    guibg=none    gui=none
hi SignColumn      guifg=none    guibg=none    gui=none
hi Folded          guifg=none    guibg=none    gui=none

" -------------------------
" - Window/Tab delimiters- 
" -------------------------
hi VertSplit       guifg=#10254C    guibg=none    gui=none
hi ColorColumn     guifg=none    guibg=#0A1323    gui=none
hi TabLine         guifg=#708bb6    guibg=#142033    gui=none
hi TabLineFill     guifg=none    guibg=#142033    gui=none
hi TabLineSel      guifg=#ffffff    guibg=none    gui=none

" -------------------------------
" - File Navigation / Searching -
" -------------------------------
hi Directory       guifg=#51ec9f    guibg=none    gui=none
hi Search          guifg=none    guibg=#2b4064    gui=none
hi IncSearch       guifg=none    guibg=#2b4064    gui=none

" -----------------
" - Prompt/Status -
" -----------------

hi StatusLine      guifg=#556886    guibg=#051022    gui=none
hi StatusLineNC    guifg=#708bb6    guibg=#142033    gui=none
hi WildMenu        guifg=#051022    guibg=#a4afed    gui=none
hi Question        guifg=#e46369    guibg=none    gui=none
hi Title           guifg=none    guibg=none    gui=none
hi MoreMsg         guifg=#faaa74    guibg=none    gui=none

" --------------
" - Visual aid -
" --------------
hi MatchParen      guifg=#fa9474    guibg=none    gui=none
hi Visual          guifg=none    guibg=#2b4064    gui=none
hi VisualNOS       guifg=none    guibg=#2b4064    gui=none
hi NonText         guifg=#556886    guibg=none    gui=none

hi Todo            guifg=#e46369    guibg=none    gui=none
hi Underlined      guifg=none    guibg=none    gui=underline
hi Error           guifg=#f1454c    guibg=none    gui=none
hi ErrorMsg        guifg=#f1454c    guibg=none    gui=underline
hi WarningMsg      guifg=#faaa74    guibg=none    gui=bold
hi Ignore          guifg=none    guibg=none    gui=none
hi SpecialKey      guifg=none    guibg=none    gui=none

" --------------------------------
" Variable types
" --------------------------------
hi Constant        guifg=#9fe0cd    guibg=none    gui=none
hi String          guifg=#bff0ff    guibg=none    gui=none
hi Number          guifg=#0ef0f0    guibg=none    gui=none
hi Boolean         guifg=#0ef0f0    guibg=none    gui=none
hi Float           guifg=#0ef0f0    guibg=none    gui=none

hi Identifier      guifg=#faaa74    guibg=none    gui=none
hi Function        guifg=#32d2d0    guibg=none    gui=none

" --------------------------------
" Language constructs
" --------------------------------
hi Statement       guifg=#449dbb    guibg=none    gui=italic
hi Conditional     guifg=#a4bbed    guibg=none    gui=none
hi Repeat          guifg=none    guibg=none    gui=none
hi Label           guifg=none    guibg=none    gui=none
hi Operator        guifg=#51ec9f    guibg=none    gui=none
hi Keyword         guifg=none    guibg=none    gui=none
hi Exception       guifg=#faaa74    guibg=none    gui=none
hi Comment         guifg=#556886    guibg=none    gui=italic

hi Special         guifg=#c494d1    guibg=none    gui=none
hi SpecialChar     guifg=#a4bbed    guibg=none    gui=none
hi Delimiter       guifg=#c494d1    guibg=none    gui=none
hi SpecialComment  guifg=#a4bbed    guibg=none    gui=none


" ----------
" - C like -
" ----------
hi PreProc         guifg=#449dbb    guibg=none    gui=none
hi Include         guifg=#44aabb    guibg=none    gui=italic
hi Define          guifg=none    guibg=none    gui=none
hi Macro           guifg=none    guibg=none    gui=none
hi PreCondit       guifg=none    guibg=none    gui=none

hi Type            guifg=#fde182    guibg=none    gui=none
hi StorageClass    guifg=#449dbb    guibg=none    gui=none
hi Structure       guifg=none    guibg=none    gui=none
hi Typedef         guifg=none    guibg=none    gui=none

" --------------------------------
" Diff
" --------------------------------
hi DiffAdd guibg=#416166 gui=bold
hi DiffChange guifg=#faaa74 guibg=none gui=bold
hi DiffDelete guifg=#f1454c guibg=none gui=bold
hi DiffText guibg=#685f3f gui=none cterm=none

" --------------------------------
" Completion menu
" --------------------------------
hi Pmenu guifg=#556886 guibg=#051022 gui=none
hi PmenuSel guifg=none guibg=#032e4b gui=none
hi PmenuSbar guifg=none guibg=#182946 gui=none
hi PmenuThumb guifg=none guibg=none gui=none

" --------------------------------
" Spelling
" --------------------------------
hi SpellBad guifg=#f1454c gui=underline
hi SpellCap gui=underline
hi SpellLocal guifg=#f1454c gui=underline
hi SpellRare guifg=#faaa74 gui=underline

"--------------------------------------------------------------------
" Specific settings                                                 |
"-------------------------------------------------------------------- 
hi jsModuleBraces guifg=#a4afed
hi jsModuleKeyword guifg=#9fe0cd
hi jsString guifg=#bff0ff
hi jsVariableDef guifg=#32d2d0
hi jsParens guifg=#c494d1
hi jsObject guifg=#a4afed
hi jsObjectShorthandProp guifg=#9fe0cd
hi jsObjectSeparator guifg=#a4afed
hi jsObjectProp guifg=#87f2f2
hi jsObjectBraces guifg=#a4afed
hi jsObjectKey guifg=#4397cf
hi jsObjectValue guifg=#9fe0cd
hi jsGlobalObjects guifg=#fa9474
hi jsArrowFunction guifg=#449dbb
hi jsArrowFuncArgs guifg=#51ec9f
hi jsFuncBlock guifg=#66ddff
hi jsBrackets guifg=#c494d1
hi jsDot guifg=#a4afed
hi jsReturn guifg=#a4bbed gui=italic
hi jsNull guifg=#0ef0f0

hi jsxOpenPunct guifg=#e46369
hi jsxClosePunct guifg=#e46369
hi jsxCloseString guifg=#e46369
hi jsxExpressionBlock guifg=#66ddff
hi jsxComponentName guifg=#faaa74

hi styledPrefix guifg=#9fe0cd
hi styledAmpersand guifg=#faaa74
hi cssTagName guifg=#faaa74
hi cssClassName guifg=#ffcb6b
hi cssBoxProp guifg=#4397cf
hi cssFontProp guifg=#4397cf

hi vimIsCommand guifg=#87f2f2
hi vimOption guifg=#87f2f2
hi vimBracket guifg=#e46369
hi vimNotation guifg=#faaa74
hi vimFuncSID guifg=#faaa74
hi vimSetEqual guifg=#51ec9f

hi CocErrorSign guifg=#f1454c guibg=none gui=bold
hi CocErrorFloat guifg=#f1454c guibg=none gui=none
hi CocWarningSign guifg=#faaa74 guibg=none gui=bold

hi graphqlStructure guifg=#449dbb
hi graphqlBraces guifg=#a4afed
hi graphqlName guifg=#9fe0cd
hi graphqlType guifg=#b2ccd6

hi jsonKeyword guifg=#4397cf
hi jsonQuote guifg=#a4afed
hi jsonBraces guifg=#a4afed
hi jsonBrackets guifg=#a4afed

hi dockerfileKeywords guifg=#449dbb
hi dockercomposeKeywords guifg=#449dbb

hi yamlKey guifg=#449dbb

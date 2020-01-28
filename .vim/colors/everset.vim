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
hi Normal guifg=#a8cfe9 guibg=#0e192c gui=NONE
hi Cursor guifg=NONE guibg=#fa9474 gui=NONE
hi CursorLine guifg=NONE guibg=#051022 gui=NONE
hi LineNr guifg=#8086a8 guibg=NONE gui=NONE
hi CursorLineNR guifg=#d6d9ec guibg=NONE gui=NONE

" -----------------
" - Number column -
" -----------------
hi CursorColumn    guifg=NONE    guibg=#051022    gui=NONE
hi FoldColumn      guifg=NONE    guibg=NONE    gui=NONE
hi SignColumn      guifg=NONE    guibg=NONE    gui=NONE
hi Folded          guifg=NONE    guibg=NONE    gui=NONE

" -------------------------
" - Window/Tab delimiters- 
" -------------------------
hi VertSplit       guifg=#10254C    guibg=NONE    gui=NONE
hi ColorColumn     guifg=NONE    guibg=#0A1323    gui=NONE
hi TabLine         guifg=#708bb6    guibg=#142033    gui=NONE
hi TabLineFill     guifg=NONE    guibg=#142033    gui=NONE
hi TabLineSel      guifg=#ffffff    guibg=NONE    gui=NONE

" -------------------------------
" - File Navigation / Searching -
" -------------------------------
hi Directory       guifg=#51ec9f    guibg=NONE    gui=NONE
hi Search          guifg=NONE    guibg=#2b4064    gui=NONE
hi IncSearch       guifg=NONE    guibg=#2b4064    gui=NONE

" -----------------
" - Prompt/Status -
" -----------------

hi StatusLine      guifg=#556886    guibg=#051022    gui=NONE
hi StatusLineNC    guifg=#708bb6    guibg=#142033    gui=NONE
hi WildMenu        guifg=#051022    guibg=#a4afed    gui=NONE
hi Question        guifg=#e46369    guibg=NONE    gui=NONE
hi Title           guifg=NONE    guibg=NONE    gui=NONE
hi MoreMsg         guifg=#faaa74    guibg=NONE    gui=NONE

" --------------
" - Visual aid -
" --------------
hi MatchParen      guifg=#fa9474    guibg=NONE    gui=NONE
hi Visual          guifg=NONE    guibg=#2b4064    gui=NONE
hi VisualNOS       guifg=NONE    guibg=#2b4064    gui=NONE
hi NonText         guifg=#556886    guibg=NONE    gui=NONE

hi Todo            guifg=#e46369    guibg=NONE    gui=NONE
hi Underlined      guifg=NONE    guibg=NONE    gui=underline
hi Error           guifg=#f1454c    guibg=NONE    gui=NONE
hi ErrorMsg        guifg=#f1454c    guibg=NONE    gui=underline
hi WarningMsg      guifg=#faaa74    guibg=NONE    gui=bold
hi Ignore          guifg=NONE    guibg=NONE    gui=NONE
hi SpecialKey      guifg=NONE    guibg=NONE    gui=NONE

" --------------------------------
" Variable types
" --------------------------------
hi Constant        guifg=#9fe0cd    guibg=NONE    gui=NONE
hi String          guifg=#bff0ff    guibg=NONE    gui=NONE
hi Number          guifg=#0ef0f0    guibg=NONE    gui=NONE
hi Boolean         guifg=#0ef0f0    guibg=NONE    gui=NONE
hi Float           guifg=#0ef0f0    guibg=NONE    gui=NONE

hi Identifier      guifg=#faaa74    guibg=NONE    gui=NONE
hi Function        guifg=#32d2d0    guibg=NONE    gui=NONE

" --------------------------------
" Language constructs
" --------------------------------
hi Statement       guifg=#449dbb    guibg=NONE    gui=italic
hi Conditional     guifg=#a4bbed    guibg=NONE    gui=NONE
hi Repeat          guifg=NONE    guibg=NONE    gui=NONE
hi Label           guifg=NONE    guibg=NONE    gui=NONE
hi Operator        guifg=#51ec9f    guibg=NONE    gui=NONE
hi Keyword         guifg=NONE    guibg=NONE    gui=NONE
hi Exception       guifg=#faaa74    guibg=NONE    gui=NONE
hi Comment         guifg=#556886    guibg=NONE    gui=italic

hi Special         guifg=#c494d1    guibg=NONE    gui=NONE
hi SpecialChar     guifg=#a4bbed    guibg=NONE    gui=NONE
hi Delimiter       guifg=#c494d1    guibg=NONE    gui=NONE
hi SpecialComment  guifg=#a4bbed    guibg=NONE    gui=NONE


" ----------
" - C like -
" ----------
hi PreProc         guifg=#449dbb    guibg=NONE    gui=NONE
hi Include         guifg=#44aabb    guibg=NONE    gui=italic
hi Define          guifg=NONE    guibg=NONE    gui=NONE
hi Macro           guifg=NONE    guibg=NONE    gui=NONE
hi PreCondit       guifg=NONE    guibg=NONE    gui=NONE

hi Type            guifg=#fde182    guibg=NONE    gui=NONE
hi StorageClass    guifg=#449dbb    guibg=NONE    gui=NONE
hi Structure       guifg=NONE    guibg=NONE    gui=NONE
hi Typedef         guifg=NONE    guibg=NONE    gui=NONE

" --------------------------------
" Diff
" --------------------------------
hi DiffAdd guibg=#416166 gui=bold
hi DiffChange guifg=#faaa74 guibg=NONE gui=bold
hi DiffDelete guifg=#f1454c guibg=NONE gui=bold
hi DiffText guibg=#685f3f gui=NONE cterm=NONE

" --------------------------------
" Completion menu
" --------------------------------
hi Pmenu guifg=#556886 guibg=#051022 gui=NONE
hi PmenuSel guifg=NONE guibg=#032e4b gui=NONE
hi PmenuSbar guifg=NONE guibg=#182946 gui=NONE
hi PmenuThumb guifg=NONE guibg=NONE gui=NONE

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

hi CocErrorSign guifg=#f1454c guibg=NONE gui=bold
hi CocErrorFloat guifg=#f1454c guibg=NONE gui=NONE
hi CocWarningSign guifg=#faaa74 guibg=NONE gui=bold

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

hi mkdHeading guifg=#4397cf
hi mkdUrl guifg=#96f1f1 gui=underline
hi mkdCode guifg=#bff0ff
hi mkdBold guifg=#a4afed
hi mkdListItem guifg=#a4afed
hi mkdLink guifg=#82aaff
hi mkdCodeStart guifg=#4397cf
hi mkdCodeEnd guifg=#4397cf
hi mkdCodeDelimiter guifg=#4397cf

hi htmlH1 guifg=#96f1f1
hi htmlBold guifg=#f07178

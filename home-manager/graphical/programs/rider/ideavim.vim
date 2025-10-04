set incsearch
" set hlsearch
set gdefault
set ignorecase
set smartcase
set showmode
set relativenumber
set number
set shell=powershell.exe
set showcmd
set showmode
set clipboard+=unnamed
set clipboard+=ideaput
set visualbell
set noerrorbells
set notimeout
set undolevels=10000
set scrolloff=12
set sidescrolloff=12
let mapleader=" "

" IdeaVim specific options
sethandler a:vim
set idearefactormode=keep
set ideaglobalmode
set ideajoin
set ideastatusicon=gray
set ideamarks
set showmodewidget
set noideadelaymacro
set ideavimsupport+=dialog
" below does not seem to work in Rider, can't use ideavim in rename symbol dialog
set ideavimsupport+=singleline

""" Plugins
set which-key
let g:WhichKey_Divider = " → "
let g:WhichKey_FontFamily = "JetBrains Mono"
let g:WhichKey_FontSize = 16
let g:WhichKey_KeyStyle = "bold"
let g:WhichKey_KeyColor = "default"
let g:WhichKey_PrefixStyle = "none"
let g:WhichKey_PrefixColor = "#f5e893"
let g:WhichKey_CommandStyle = "none"
let g:WhichKey_CommandColor = "#bca0dc"
let g:WhichKey_SortOrder = "by_key_prefix_first"
let g:WhichKey_SortCaseSensitive = "false"
let g:WhichKey_ProcessUnknownMappings = "false"
let g:WhichKey_DefaultDelay = 200
let g:WhichKey_ShowTypedSequence = "false"

set highlightedyank
set vim-paragraph-motion
set textobj-indent
set textobj-entire
set functiontextobj

set argtextobj
let g:argtextobj_pairs="(:),{:},<:>"

set quickscope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_disable_for_diffs = 1
let g:qs_primary_color = '#B57EDC'

set ReplaceWithRegister
let g:WhichKeyDesc_replace = "gr Replace with register"

set commentary
let g:WhichKeyDesc_gc = "gc Comment"
let g:WhichKeyDesc_gcc = "gcc Comment line"
let g:WhichKeyDesc_gcu = "gcu Uncomment"

set NERDTree
nmap - <Plug>NERDTreeToggle

"set exchange
"let g:WhichKeyDesc_cx = "cx"
"let g:WhichKeyDesc_cxc = "cxc Exchange clear"
"let g:WhichKeyDesc_cxx = "cxx Exchange line"

set surround
let g:WhichKeyDesc_surround_sa = "sa Surround"
let g:WhichKeyDesc_surround_sd = "sd Delete surrounding"
let g:WhichKeyDesc_surround_sr = "sr Change surrounding"
nnoremap sa ys
nnoremap sd ds
nnoremap sr cs

set multiple-cursors
nmap x <Plug>NextWholeOccurrence
xmap x <Plug>NextWholeOccurrence
omap x <Plug>NextWholeOccurrence
nmap X <Plug>AllWholeOccurrences
xmap X <Plug>AllWholeOccurrences
omap X <Plug>AllWholeOccurrences
"nmap ss <S-C-n>bv
"xmap ss <S-C-n>bv
"omap ss <S-C-n>bv
"nmap <C-n> <Plug>NextWholeOccurrence
"xmap <C-n> <Plug>NextWholeOccurrence
"omap <C-n> <Plug>NextWholeOccurrence
"nmap g<C-n> <Plug>NextOccurrence
"xmap g<C-n> <Plug>NextOccurrence
"omap g<C-n> <Plug>NextOccurrence
"xmap <C-x> <Plug>SkipOccurrence
"xmap <C-p> <Plug>RemoveOccurrence
"nmap <S-C-n> <Plug>AllWholeOccurrences
"xmap <S-C-n> <Plug>AllWholeOccurrences
"omap <S-C-n> <Plug>AllWholeOccurrences
"nmap g<S-C-n> <Plug>AllOccurrences
"xmap g<S-C-n> <Plug>AllOccurrences
"omap g<S-C-n> <Plug>AllOccurrences

""" Maps

" Universal show
" nmap <Tab> <Action>(ParameterInfo)<Action>(ShowErrorDescription)
" vmap <Tab> <Action>(ParameterInfo)<Action>(ShowErrorDescription)

" Insert mode
imap <c-w> <Action>(EditorDeleteToWordStartInDifferentHumpsMode)

" Easy splits
nmap <c-h> <c-w>h
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l
nmap <c-s> <c-w>s
nmap <c-v> <c-w>v
nmap <c-c> <Action>(CloseContent)

" Easy move element
nmap <a-h> <Action>(MoveElementLeft)
nmap <a-j> <Action>(MoveStatementDown)
nmap <a-k> <Action>(MoveStatementUp)
nmap <a-l> <Action>(MoveElementRight)

" Jumping
nmap <c-o> <Action>(Back)
nmap <c-i> <Action>(Forward)

" Change before and after
nmap <C-B> WBi<Space><Esc>i
nmap <C-F> WBea<Space>

" Do not overwrite unnamed register with x
nnoremap x "_x

" " Maintain visual selection after indenting
" vmap < <gv
" vmap > >gv

" Copilot
" imap <c-p> <Action>(copilot.applyInlays)
" nmap <c-p> <Action>(copilot.applyInlays)
" vmap <c-p> <Action>(copilot.applyInlays)
" imap <c-[> <Action>(copilot.cycleNextInlays)
" nmap <c-[> <Action>(copilot.cycleNextInlays)
" vmap <c-[> <Action>(copilot.cycleNextInlays)
" imap <c-]> <Action>(copilot.cyclePrevInlays)
" nmap <c-]> <Action>(copilot.cyclePrevInlays)
" vmap <c-]> <Action>(copilot.cyclePrevInlays)
" inoremap <c-P> <Action>(copilot.requestCompletions)
" nnoremap <c-P> <Action>(copilot.requestCompletions)
" vnoremap <c-P> <Action>(copilot.requestCompletions)

" Other
" nmap <c-s> :action FileStructurePopup<CR>
" nmap <c-m> :action MoveEditorToOppositeTabGroup<CR>
" nmap <c-x> :action HideAllWindows<CR>

" Quick go to
nmap gu <Action>(ShowUsages)
vmap gu <Action>(ShowUsages)
let g:WhichKeyDesc_Quick_gu = "gu Go to usages"
nmap gd <Action>(GotoDeclaration)
vmap gd <Action>(GotoDeclaration)
let g:WhichKeyDesc_Quick_gd = "gd Go to declaration"
nmap gt <Action>(GotoTypeDeclaration)
vmap gt <Action>(GotoTypeDeclaration)
let g:WhichKeyDesc_Quick_gt = "gt Go to type declaration"
nmap gi <Action>(GotoImplementation)
vmap gi <Action>(GotoImplementation)
let g:WhichKeyDesc_Quick_gi = "gi Go to implementation"
nmap gp <Action>(GotToSuperMethod)
vmap gp <Action>(GotToSuperMethod)
let g:WhichKeyDesc_Quick_gp = "gp Go to parent method"
nmap ge <Action>(ReSharperGotoNextErrorInSolution)
vmap ge <Action>(ReSharperGotoNextErrorInSolution)
let g:WhichKeyDesc_Quick_ge = "ge Go to next error in solution"
nmap gE <Action>(ReSharperGotoPreviousErrorInSolution)
vmap gE <Action>(ReSharperGotoPreviousErrorInSolution)
let g:WhichKeyDesc_Quick_gE = "gE Go to previous error in solution"
nmap gw <Action>(GotoNextError)
vmap gw <Action>(GotoNextError)
let g:WhichKeyDesc_Quick_gw = "gw Go to next warning or error"
nmap gW <Action>(GotoPreviousError)
vmap gW <Action>(GotoPreviousError)
let g:WhichKeyDesc_Quick_gW = "gW Go to previous warning or error"
nmap gm <Action>(MethodDown)
vmap gm <Action>(MethodDown)
let g:WhichKeyDesc_Quick_gm = "gm Go to next method"
nmap gM <Action>(MethodUp)
vmap gM <Action>(MethodUp)
let g:WhichKeyDesc_Quick_gM = "gM Go to previous method"
nmap gV <Action>(VcsShowPrevChangeMarker)
vmap gV <Action>(VcsShowPrevChangeMarker)
let g:WhichKeyDesc_Quick_gV = "gV Go to previous VCS change"
nmap gv <Action>(VcsShowNextChangeMarker)
vmap gv <Action>(VcsShowNextChangeMarker)
let g:WhichKeyDesc_Quick_gv = "gv Go to next VCS change"
nmap gl <Action>(JumpToLastChange)
vmap gl <Action>(JumpToLastChange)
let g:WhichKeyDesc_Quick_gl = "gl Go to last change"
nmap gT <Action>(GotoTest)
vmap gT <Action>(GotoTest)
let g:WhichKeyDesc_Quick_gT = "gT Go to test"

""" Action picker
let g:WhichKeyDesc_leader = "<leader> Actions"
let g:WhichKeyDesc_u = "<leader>u Unity"
nmap <leader>up <Action>(TriggerPlayInUnity)
vmap <leader>up <Action>(TriggerPlayInUnity)
let g:WhichKeyDesc_up = "<leader>up Enter playmode"
vmap <leader>ur <Action>(TriggerRefreshInUnity)
nmap <leader>ur <Action>(TriggerRefreshInUnity)
let g:WhichKeyDesc_ur = "<leader>ur Refresh editor"
nmap <leader>us <Action>(StartUnityAction)
vmap <leader>us <Action>(StartUnityAction)
let g:WhichKeyDesc_us = "<leader>us Start editor"
nmap <leader>uw <Action>(ActivateUnityToolWindow)
vmap <leader>uw <Action>(ActivateUnityToolWindow)
let g:WhichKeyDesc_uw = "<leader>uw Show Unity tool window"
nmap <leader>ua <Action>(AttachToUnityEditorAction)
vmap <leader>ua <Action>(AttachToUnityEditorAction)
let g:WhichKeyDesc_ua = "<leader>ua Attach debugger to editor"
nmap <leader>uA <Action>(AttackToUnityProcessAction)
vmap <leader>uA <Action>(AttackToUnityProcessAction)
let g:WhichKeyDesc_uA = "<leader>uA Attach debugger to process"
nmap <leader>uf <Action>(com.jetbrains.rider.plugins.unity.actions.ShowFileInUnityAction)
vmap <leader>uf <Action>(com.jetbrains.rider.plugins.unity.actions.ShowFileInUnityAction)
let g:WhichKeyDesc_uf = "<leader>uf Show current file in Unity editor"
nmap <leader>ut <Action>(UnityTestLauncher)
vmap <leader>ut <Action>(UnityTestLauncher)
let g:WhichKeyDesc_ut = "<leader>ut Launch Unity tests"
nmap <leader>ul <Action>(RiderUnityOpenEditorLogAction)
vmap <leader>ul <Action>(RiderUnityOpenEditorLogAction)
let g:WhichKeyDesc_ul = "<leader>ul Open Unity editor log"
nmap <leader>uL <Action>(RiderUnityOpenPlayerLogAction)
vmap <leader>uL <Action>(RiderUnityOpenPlayerLogAction)
let g:WhichKeyDesc_uL = "<leader>uL Open Unity Player log"

let g:WhichKeyDesc_g = "<leader>g Go"
nmap <leader>gu <Action>(ShowUsages)
vmap <leader>gu <Action>(ShowUsages)
let g:WhichKeyDesc_gu = "<leader>gu Go to usages"
nmap <leader>gt <Action>(GotoTest)
vmap <leader>gt <Action>(GotoTest)
let g:WhichKeyDesc_gt = "<leader>gt Go to test"
nmap <leader>gX <Action>(GotoPreviousError)
vmap <leader>gX <Action>(GotoPreviousError)
let g:WhichKeyDesc_gX = "<leader>gX Go to previous error"
nmap <leader>gC <Action>(VcsShowPrevChangeMarker)
vmap <leader>gC <Action>(VcsShowPrevChangeMarker)
let g:WhichKeyDesc_gC = "<leader>gC Go to previous VCS change"
nmap <leader>gb <Action>(Back)
vmap <leader>gb <Action>(Back)
let g:WhichKeyDesc_gb = "<leader>gb Go back"
nmap <leader>gf <Action>(Forward)
vmap <leader>gf <Action>(Forward)
let g:WhichKeyDesc_gf = "<leader>gf Go forward"
nmap <leader>gE <Action>(ReSharperGotoPreviousErrorInSolution)
vmap <leader>gE <Action>(ReSharperGotoPreviousErrorInSolution)
let g:WhichKeyDesc_gE = "<leader>gE Go to previous error in solution"
nmap <leader>gd <Action>(GotoDeclaration)
vmap <leader>gd <Action>(GotoDeclaration)
let g:WhichKeyDesc_gd = "<leader>gd Go to declaration"
nmap <leader>gj <Action>(JumpToLastChange)
vmap <leader>gj <Action>(JumpToLastChange)
let g:WhichKeyDesc_gj = "<leader>gj Go to last change"
nmap <leader>gi <Action>(GotoImplementation)
vmap <leader>gi <Action>(GotoImplementation)
let g:WhichKeyDesc_gi = "<leader>gi Go to implementation"
nmap <leader>ge <Action>(ReSharperGotoNextErrorInSolution)
vmap <leader>ge <Action>(ReSharperGotoNextErrorInSolution)
let g:WhichKeyDesc_ge = "<leader>ge Go to next error in solution"
nmap <leader>gm <Action>(MethodDown)
vmap <leader>gm <Action>(MethodDown)
let g:WhichKeyDesc_gm = "<leader>gm Go to next method"
nmap <leader>gx <Action>(GotoNextError)
vmap <leader>gx <Action>(GotoNextError)
let g:WhichKeyDesc_gx = "<leader>gx Go to next error"
nmap <leader>gM <Action>(MethodUp)
vmap <leader>gM <Action>(MethodUp)
let g:WhichKeyDesc_gM = "<leader>gM Go to previous method"
nmap <leader>gc <Action>(VcsShowNextChangeMarker)
vmap <leader>gc <Action>(VcsShowNextChangeMarker)
let g:WhichKeyDesc_gc = "<leader>gc Go to next VCS change"
nmap <leader>gD <Action>(GotoTypeDeclaration)
vmap <leader>gD <Action>(GotoTypeDeclaration)
let g:WhichKeyDesc_gD = "<leader>gD Go to type declaration"
nmap <leader>gp <Action>(GotToSuperMethod)
vmap <leader>gp <Action>(GotToSuperMethod)
let g:WhichKeyDesc_gp = "<leader>gp Go to parent method"

let g:WhichKeyDesc_v = "<leader>v Versioning"
nmap <leader>vh <Action>(Vcs.ShowTabbedFileHistory)
vmap <leader>vh <Action>(Vcs.ShowTabbedFileHistory)
let g:WhichKeyDesc_vh = "<leader>vh History"
nmap <leader>vp <Action>(Vcs.UpdateProject)
vmap <leader>vp <Action>(Vcs.UpdateProject)
let g:WhichKeyDesc_vp = "<leader>vp Pull"
nmap <leader>vc <Action>(CheckinProject)
vmap <leader>vc <Action>(CheckinProject)
let g:WhichKeyDesc_vc = "<leader>vc Commit"
nmap <leader>vd <Action>(Compare.SameVersion)
vmap <leader>vd <Action>(Compare.SameVersion)
let g:WhichKeyDesc_vd = "<leader>vd Diff same version"
nmap <leader>vr <Action>(ChangesView.Revert)
vmap <leader>vr <Action>(ChangesView.Revert)
let g:WhichKeyDesc_vr = "<leader>vr Revert"
nmap <leader>vb <Action>(Annotate)
vmap <leader>vb <Action>(Annotate)
let g:WhichKeyDesc_vb = "<leader>vb Blame"
nmap <leader>vs <Action>(Vcs.Show.Log)
vmap <leader>vs <Action>(Vcs.Show.Log)
let g:WhichKeyDesc_vs = "<leader>vs Status"

let g:WhichKeyDesc_d = "<leader>d Debug"
nmap <leader>dv <Action>(ViewBreakpoints)
vmap <leader>dv <Action>(ViewBreakpoints)
let g:WhichKeyDesc_dv = "<leader>dv View breakpoints"
nmap <leader>dt <Action>(ToggleLineBreakpoint)
vmap <leader>dt <Action>(ToggleLineBreakpoint)
let g:WhichKeyDesc_dt = "<leader>dt Toggle line breakpoint"
nmap <leader>dc <Action>(ChooseDebugConfiguration)
vmap <leader>dc <Action>(ChooseDebugConfiguration)
let g:WhichKeyDesc_dc = "<leader>dc Choose debug configuration"
nmap <leader>dr <Action>(Debugger.RemoveAllBreakpoints)
vmap <leader>dr <Action>(Debugger.RemoveAllBreakpoints)
let g:WhichKeyDesc_dr = "<leader>dr Remove all breakpoints"
nmap <leader>ds <Action>(Stop)
vmap <leader>ds <Action>(Stop)
let g:WhichKeyDesc_ds = "<leader>ds Stop"
nmap <leader>dd <Action>(Debug)
vmap <leader>dd <Action>(Debug)
let g:WhichKeyDesc_dd = "<leader>dd Debug"

let g:WhichKeyDesc_i = "<leader>i AI"
nmap <leader>ir <Action>(copilot.requestCompletions)
vmap <leader>ir <Action>(copilot.requestCompletions)
let g:WhichKeyDesc_ir = "<leader>ir Request completions"
nmap <leader>in <Action>(copilot.cycleNextInlays)
vmap <leader>in <Action>(copilot.cycleNextInlays)
let g:WhichKeyDesc_in = "<leader>in Next completion"
nmap <leader>ia <Action>(copilot.applyInlays)
vmap <leader>ia <Action>(copilot.applyInlays)
let g:WhichKeyDesc_ia = "<leader>ia Apply completion"
nmap <leader>iN <Action>(copilot.cyclePrevInlays)
vmap <leader>iN <Action>(copilot.cyclePrevInlays)
let g:WhichKeyDesc_iN = "<leader>iN Previous completion"

let g:WhichKeyDesc_f = "<leader>f Find"
nmap <leader>fd <Action>(SearchEverywhere)
vmap <leader>fd <Action>(SearchEverywhere)
let g:WhichKeyDesc_fd = "<leader>fd Search everywhere"
nmap <leader>fc <Action>(GotoClass)
vmap <leader>fc <Action>(GotoClass)
let g:WhichKeyDesc_fc = "<leader>fc Search classes"
nmap <leader>fr <Action>(Replace)
vmap <leader>fr <Action>(Replace)
let g:WhichKeyDesc_fr = "<leader>fr Replace"
nmap <leader>fa <Action>(GotoAction)
vmap <leader>fa <Action>(GotoAction)
let g:WhichKeyDesc_fa = "<leader>fa Search actions"
nmap <leader>fg <Action>(FindInPath)
vmap <leader>fg <Action>(FindInPath)
let g:WhichKeyDesc_fg = "<leader>fg Grep"

let g:WhichKeyDesc_m = "<leader>m Move"
nmap <leader>mf <Action>(Move)
vmap <leader>mf <Action>(Move)
let g:WhichKeyDesc_mf = "<leader>mf Move file"
nmap <leader>ml <Action>(MoveElementRight)
vmap <leader>ml <Action>(MoveElementRight)
let g:WhichKeyDesc_ml = "<leader>ml Move element right"
nmap <leader>mk <Action>(MoveStatementUp)
vmap <leader>mk <Action>(MoveStatementUp)
let g:WhichKeyDesc_mk = "<leader>mk Move element up"
nmap <leader>mj <Action>(MoveStatementDown)
vmap <leader>mj <Action>(MoveStatementDown)
let g:WhichKeyDesc_mj = "<leader>mj Move element down"
nmap <leader>mh <Action>(MoveElementLeft)
vmap <leader>mh <Action>(MoveElementLeft)
let g:WhichKeyDesc_mh = "<leader>mh Move element left"

let g:WhichKeyDesc_b = "<leader>b Bookmarks"
nmap <leader>bs <Action>(ShowBookmarks)
vmap <leader>bs <Action>(ShowBookmarks)
let g:WhichKeyDesc_bs = "<leader>bs Show bookmarks"
nmap <leader>bt <Action>(ToggleBookmark)
vmap <leader>bt <Action>(ToggleBookmark)
let g:WhichKeyDesc_bt = "<leader>bt Toggle bookmark"

let g:WhichKeyDesc_c = "<leader>c Configuration"
nmap <leader>ce :e ~/.ideavimrc<CR>
vmap <leader>ce :e ~/.ideavimrc<CR>
let g:WhichKeyDesc_ce = "<leader>ce Edit .ideavimrc"
nmap <leader>cr <Action>(IdeaVim.ReloadVimRc.reload)
vmap <leader>cr <Action>(IdeaVim.ReloadVimRc.reload)
let g:WhichKeyDesc_cr = "<leader>cr Reload .ideavimrc"
nmap <leader>cw <Action>(EditorToggleUseSoftWraps)
vmap <leader>cw <Action>(EditorToggleUseSoftWraps)
let g:WhichKeyDesc_cw = "<leader>cw Toggle soft wraps"
nmap <leader>cz <Action>(ToggleDistractionFreeMode)
vmap <leader>cz <Action>(ToggleDistractionFreeMode)
let g:WhichKeyDesc_cz = "<leader>cz Toggle zen mode"
nmap <leader>ca <Action>(VimFindActionIdAction)
vmap <leader>ca <Action>(VimFindActionIdAction)
let g:WhichKeyDesc_ca = "<leader>ca Toggle show performed actions"

let g:WhichKeyDesc_r = "<leader>r Refactor"
nmap <leader>rg <Action>(Generate)
vmap <leader>rg <Action>(Generate)
let g:WhichKeyDesc_rg = "<leader>rg Generate"
nmap <leader>rv <Action>(IntroduceVariable)
vmap <leader>rv <Action>(IntroduceVariable)
let g:WhichKeyDesc_rv = "<leader>rv Introduce variable"
nmap <leader>re <Action>(RiderBackendAction-EncapsulateField)
vmap <leader>re <Action>(RiderBackendAction-EncapsulateField)
let g:WhichKeyDesc_re = "<leader>re Encapsulate field"
nmap <leader>rt <Action>(Refactorings.QuickListPopupAction)
vmap <leader>rt <Action>(Refactorings.QuickListPopupAction)
let g:WhichKeyDesc_rt = "<leader>rt Refactor this"
nmap <leader>ri <Action>(Inline)
vmap <leader>ri <Action>(Inline)
let g:WhichKeyDesc_ri = "<leader>ri Inline"
nmap <leader>rf <Action>(IntroduceField)
vmap <leader>rf <Action>(IntroduceField)
let g:WhichKeyDesc_rf = "<leader>rf Introduce field"
nmap <leader>rI <Action>(ExtractInterface)
vmap <leader>rI <Action>(ExtractInterface)
let g:WhichKeyDesc_rI = "<leader>rI Extract interface"
nmap <leader>rm <Action>(ExtractMethod)
vmap <leader>rm <Action>(ExtractMethod)
let g:WhichKeyDesc_rm = "<leader>rm Extract method"
nmap <leader>rF <Action>(ReformatCode)
vmap <leader>rF <Action>(ReformatCode)
let g:WhichKeyDesc_rF = "<leader>rF Reformat Code"
nmap <leader>rs <Action>(ChangeSignature)
vmap <leader>rs <Action>(ChangeSignature)
let g:WhichKeyDesc_rs = "<leader>rs Change signature"
nmap <leader>rr <Action>(RenameElement)
vmap <leader>rr <Action>(RenameElement)
let g:WhichKeyDesc_rr = "<leader>rr Rename element"
nmap <leader>ra <Action>(ShowIntentionActions)
vmap <leader>ra <Action>(ShowIntentionActions)
let g:WhichKeyDesc_ra = "<leader>ra Intention Actions"
nmap <leader>rp <Action>(IntroduceParameter)
vmap <leader>rp <Action>(IntroduceParameter)
let g:WhichKeyDesc_rp = "<leader>rp Introduce parameter"

let g:WhichKeyDesc_a = "<leader>a Auto-format"
nmap <leader>ai <Action>(OptimizeImports)
vmap <leader>ai <Action>(OptimizeImports)
let g:WhichKeyDesc_ai = "<leader>ai Optimize imports"
nmap <leader>af <Action>(CodeCleanup)
vmap <leader>af <Action>(CodeCleanup)
let g:WhichKeyDesc_af = "<leader>af Cleanup"
nmap <leader>aa <Action>(SilentCodeCleanup)
vmap <leader>aa <Action>(SilentCodeCleanup)
let g:WhichKeyDesc_aa = "<leader>aa Cleanup silent"
nmap <leader>ad <Action>(ReformatCode)
vmap <leader>ad <Action>(ReformatCode)
let g:WhichKeyDesc_ad = "<leader>ad Reformat Code"

let g:WhichKeyDesc_s = "<leader>s Show"
nmap <leader>se <Action>(ShowErrorDescription)
vmap <leader>se <Action>(ShowErrorDescription)
let g:WhichKeyDesc_se = "<leader>se Error description"
nmap <leader>sd <Action>(QuickJavaDoc)
vmap <leader>sd <Action>(QuickJavaDoc)
let g:WhichKeyDesc_sd = "<leader>sd Documentation"
nmap <leader>sq <Action>(QuickPreview)
vmap <leader>sq <Action>(QuickPreview)
let g:WhichKeyDesc_sq = "<leader>sq Show quick preview"
nmap <leader>sp <Action>(ParameterInfo)
vmap <leader>sp <Action>(ParameterInfo)
let g:WhichKeyDesc_sp = "<leader>sp Show parameter info"
nmap <leader>su <Action>(FindUsages)
vmap <leader>su <Action>(FindUsages)
let g:WhichKeyDesc_su = "<leader>su Show usages"
nmap <leader>sh <Action>(CallHierarchy)
vmap <leader>sh <Action>(CallHierarchy)
let g:WhichKeyDesc_sh = "<leader>sh Show call hierarchy"
nmap <leader>sl <Action>(RecentLocations)
vmap <leader>sl <Action>(RecentLocations)
let g:WhichKeyDesc_sl = "<leader>sl Recent locations"

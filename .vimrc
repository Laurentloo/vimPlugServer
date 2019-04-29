"----Basic Configure----
set encoding=utf-8 "file encoding

syntax on
set ignorecase
"set shiftwidth=4
set t_Co=256

"cancel backup
set nobackup
set noswapfile

set nu "show line number
set hls "set highlight search

set ruler "show current cursor position
let mapleader = "\<Space>" "using Space as leader
set signcolumn=yes "强制显示侧边栏

"------------Plugin Manager---------
call plug#begin('~/.vim/plugged') " Specify a directory for plugins

Plug 'morhetz/gruvbox' " Colorscheme (includes its own airline theme)
colorscheme gruvbox
"set background=light
set background=dark

Plug 'mileszs/ack.vim'
let g:ackprg = 'ag --nogroup --nocolor --column' "map ack to ag

Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer',  'for': ['c', 'cpp'] }
"let g:ycm_global_ycm_extra_conf='~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'

"屏蔽 YCM 的诊断信息
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<c-z>'
"屏蔽自动弹出函数原型预览窗口
set completeopt=menu,menuone
let g:ycm_add_preview_to_completeopt = 0
"输入Ctrl+Z后，开始补全,Note:与挂起命令冲突，因此，注释掉
"noremap <c-z> <NOP>
"输入两个字母后弹出补全
let g:ycm_semantic_triggers =  {
           \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
           \ 'cs,lua,javascript': ['re!\w{2}'],
           \ }
"避免编辑白名单外的文件类型时 YCM也在那分析半天
let g:ycm_filetype_whitelist = { 
			\ "c":1,
			\ "cpp":1, 
			\ "objc":1,
			\ "sh":1,
			\ "zsh":1,
			\ "zimbu":1,
			\ }

Plug 'w0rp/ale'
let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1

let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''

let g:ale_sign_error = "\ue009\ue009"
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! SpellBad gui=undercurl guisp=red
hi! SpellCap gui=undercurl guisp=blue
hi! SpellRare gui=undercurl guisp=magenta

Plug 'mhinz/vim-signify'

"cpp-enhanced-highlight
Plug 'octol/vim-cpp-enhanced-highlight'
"高亮类，成员函数，标准库和模板
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
"文件较大时使用下面的设置高亮模板速度较快，但会有一些小错误
let g:cpp_experimental_template_highlight = 1

"locate file, show function list
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
" Ctrl + p 打开文件搜索
let g:Lf_ShortcutF = '<c-p>'    
"空格p 打开函数列表
noremap <Leader>p :LeaderfFunction<cr>

"gutentags
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'

"读取tags（当前目录，否则向上级目录查找添加 .tags）
set tags=./.tags;,.tags

"设置环境变量启用 pygments
let $GTAGSLABEL = 'native-pygments'
let $GTAGSCONF = '/usr/local/share/gtags/gtags.conf' " 此路径根据实际设置（find一下）

" gutentags 搜索工程目录的标志，当前文件路径向上递归直到碰到这些文件/目录名
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'
" 将自动生成的 ctags/gtags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
	silent! call mkdir(s:vim_tags, 'p')
endif

" 同时开启 ctags 和 gtags 支持：
let g:gutentags_modules = []
if executable('ctags')
	let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
	let g:gutentags_modules += ['gtags_cscope']
endif

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 如果使用 universal ctags 需要增加下面一行
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

" 禁用 gutentags 自动加载 gtags 数据库的行为
" 避免多个项目数据库相互干扰
" 使用plus插件解决问题
let g:gutentags_auto_add_gtags_cscope = 0

" gtags-cscope
"s：查找代码符号
"g：查找本定义
"c：查找调用本函数的函数
"t：查找本字符串
"e：查找本egrep模式
"f：查找本文件
"i：查找包含本文件的文件
"d：查找本函数调用的函数
" disable the defautl keymaps
let g:gutentags_plus_nomap = 1
"define our own keymaps
noremap <silent> <leader>gs :GscopeFind s <C-R><C-W><cr>
noremap <silent> <leader>gg :GscopeFind g <C-R><C-W><cr>
noremap <silent> <leader>gc :GscopeFind c <C-R><C-W><cr>
noremap <silent> <leader>gt :GscopeFind t <C-R><C-W><cr>
noremap <silent> <leader>ge :GscopeFind e <C-R><C-W><cr>
noremap <silent> <leader>gf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
noremap <silent> <leader>gi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
noremap <silent> <leader>gd :GscopeFind d <C-R><C-W><cr>
noremap <silent> <leader>ga :GscopeFind a <C-R><C-W><cr>

" change focus to quickfix window after search (optional).
let g:gutentags_plus_switch = 1
"预览 quickfix 窗口 ctrl-w z 关闭
Plug 'skywind3000/vim-preview'
"P 预览 大p关闭 
autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr> 
autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr> 
noremap <Leader>u :PreviewScroll -1<cr> " 往上滚动预览窗口
noremap <leader>d :PreviewScroll +1<cr> " 往下滚动预览窗口

Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }
Plug 'sgur/vim-textobj-parameter'

" Initialize plugin system
call plug#end()


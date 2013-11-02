exec 'source ' . getcwd() . '/plugin/buftabs.vim'
exec 'source ' . getcwd() . '/plugin/config.vim'
exec 'source ' . getcwd() . '/plugin/formatter.vim'
exec 'source ' . getcwd() . '/plugin/rooter.vim'

function! TestBasics()
  let g:buftabs_in_statusline = 1
  call Describe("when set to display in statusline")
  call Buftabs_enable()
  call Buftabs_show(-1)
  call AssertEquals(&statusline, ' 1- [2-TestOutput]')
endf




function TestComplexSetup()
  set laststatus=2
  let g:buftabs_in_statusline=1
  let g:buftabs_formatter_pattern = '[root_tail]/[short_path_letters][filename]'
  let g:buftabs_formatter_pattern_active = '<[root_tail]/[short_path_letters][filename]>'

  hi BuftabsNormal  guifg=#D2FF2F guibg=Black
  hi BuftabsActive  guifg=#FFFFFF guibg=#2EE5FA

  let g:buftabs_active_highlight_group='BuftabsActive'
  let g:buftabs_inactive_highlight_group='BuftabsNormal'

  " let statusline=%=buffers:\ %{buftabs#statusline()}

  let minwidth = 12345

  call g:BuftabsResetConfig()

  bd!
  bd!
  
  exec 'e ' . getcwd() . '/plugin/buftabs.vim'
  exec 'e ' . getcwd() . '/plugin/config.vim'
  exec 'e ' . getcwd() . '/plugin/display.vim'

  call Buftabs_show(-1)

  call AssertEquals(&statusline, '%#BuftabsNormal#ig.vim %##%#BuftabsActive#[buftabs/p/display.vim]%##%#BuftabsNormal#%##')
endfunction

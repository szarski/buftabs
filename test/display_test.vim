exec 'source ' . getcwd() . '/plugin/display.vim'

let s:fake_config = {}
function FakeConfig(k1,k2,v)
  if !(has_key(s:fake_config, a:k1))
    let s:fake_config[a:k1] = {}
  endif
  let s:fake_config[a:k1][a:k2] = a:v
endf

function g:BuftabsConfig(key1,key2)
  return s:fake_config[a:key1][a:key2]
endf

function! s:Prepare()
  call FakeConfig('highlight_group','active','AA')
  call FakeConfig('highlight_group','inactive','NN')
  call FakeConfig('highlight_group','overflow',0)
  call FakeConfig('display','statusline',1)
  let &statusline = ''
endf

function! TestBuftabsDisplayInStatuslineSelectedTab()
  call s:Prepare()

  call Describe("when first tab is active")
  call g:BuftabsDisplay(['tab1','tab2','tab3'], 1)
  call AssertEquals(&statusline, '%#NN# %##%#AA#tab1%##%#NN#  tab2  tab3 %##')

  call Describe("when second tab is active")
  call g:BuftabsDisplay(['tab1','tab2','tab3'], 2)
  call AssertEquals(&statusline, '%#NN# tab1  %##%#AA#tab2%##%#NN#  tab3 %##')

  call Describe("when last tab is active")
  call g:BuftabsDisplay(['tab1','tab2','tab3'], 3)
  call AssertEquals(&statusline, '%#NN# tab1  tab2  %##%#AA#tab3%##%#NN# %##')

  call Describe("when no tab is active")
  call g:BuftabsDisplay(['tab1','tab2','tab3'], 4)
  call AssertEquals(&statusline, '%#NN# tab1  tab2  tab3 %##')
endf

function! TestBuftabsDisplayInStatuslineTrimming()
  call s:Prepare()
  call FakeConfig('highlight_group','active',0)
  call FakeConfig('highlight_group','inactive',0)
  call FakeConfig('highlight_group','overflow',0)

  " Assumming the window width is 80 here
  call Describe("when text is too long to fit screen")


  let l:outcomes = [ [4, '<longtab3  verylongtab4  verylongtab5  verylongtab6  verylongtab7  verylongtab8 '], [3, '<verylongtab3  verylongtab4  verylongtab5  verylongtab6  verylongtab7  verylong>'], [2, '<verylongtab2  verylongtab3  verylongtab4  verylongtab5  verylongtab6  verylong>'], [1, ' verylongtab1  verylongtab2  verylongtab3  verylongtab4  verylongtab5  verylong>'] ]

  for [selected, outcome] in l:outcomes
    call g:BuftabsDisplay(['verylongtab1','verylongtab2','verylongtab3','verylongtab4','verylongtab5','verylongtab6','verylongtab7', 'verylongtab8'], selected)
    call AssertEquals(&statusline, outcome)
  endfor
endf

function! TestBuftabsDisplayInStatuslineOverwriting()
  call s:Prepare()

  let l:statusline_content="buffers: %{g:BuftabsStatusline()}"
  call Describe("when statusline is set to " . l:statusline_content)
  let &statusline=l:statusline_content
  call g:BuftabsDisplay(['tab1','tab2','tab3'], 4)
  call AssertEquals(g:BuftabsStatusline(), '%#NN# tab1  tab2  tab3 %##')
  call AssertEquals(&statusline, l:statusline_content)

  let l:statusline_content="something that does not include buftabs"
  call Describe("when statusline is set to " . l:statusline_content)
  let &statusline=l:statusline_content
  call g:BuftabsDisplay(['tab1','tab2','tab3'], 4)
  call AssertEquals(&statusline, '%#NN# tab1  tab2  tab3 %##')
endf


function! TestBuftabsDisplayOutsideStatusline()
  call s:Prepare()

  call Describe("when g:BuftabsConfig()['display']['statusline'] is false")
  let &statusline = ''
  call FakeConfig('display','statusline',0)
  call g:BuftabsDisplay(['tab1','tab2','tab3'], 2)
  call AssertEquals(&statusline, '')
endf

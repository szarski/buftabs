exec 'source ' . getcwd() . '/plugin/display.vim'

let s:fake_config = {}
function FakeConfig(k1,k2,v)
  if !(has_key(s:fake_config, a:k1))
    let s:fake_config[a:k1] = {}
  endif
  let s:fake_config[a:k1][a:k2] = a:v
endf

function g:BuftabsConfig()
  return s:fake_config
endf

function! TestBuftabsDisplayInStatusline()
  call FakeConfig('highlight_group','active','AA')
  call FakeConfig('highlight_group','inactive','NN')
  call FakeConfig('display','statusline',1)
  let &statusline = ''

  call Describe("when first tab is active")
  call g:BuftabsDisplay(['tab1','tab2','tab3'], 1)
  call AssertEquals(&statusline, '%#NN#%##%#AA#tab1%##%#NN# tab2  tab3 %##')

  call Describe("when second tab is active")
  call g:BuftabsDisplay(['tab1','tab2','tab3'], 2)
  call AssertEquals(&statusline, '%#NN# tab1 %##%#AA#tab2%##%#NN# tab3 %##')

  call Describe("when last tab is active")
  call g:BuftabsDisplay(['tab1','tab2','tab3'], 3)
  call AssertEquals(&statusline, '%#NN# tab1  tab2 %##%#AA#tab3%##%#NN#%##')

  call Describe("when no tab is active")
  call g:BuftabsDisplay(['tab1','tab2','tab3'], 4)
  call AssertEquals(&statusline, '%#NN# tab1  tab2  tab3 %##')

  " Assumming the window width is 80 here
  call Describe("when text is too long to fit screen")
  call g:BuftabsDisplay(['verylongtab1','verylongtab2','verylongtab3','verylongtab4','verylongtab5','verylongtab6','verylongtab7'], 4)
  call AssertEquals(&statusline, '%#NN#ngtab2  verylongtab3 %##%#AA#verylongtab4%##%#NN# verylongtab5  verylongtab6  verylongtab7 %##')

  call Describe("when g:BuftabsConfig()['display']['statusline'] is false")
  let &statusline = ''
  call FakeConfig('display','statusline',0)
  call g:BuftabsDisplay(['tab1','tab2','tab3'], 2)
  call AssertEquals(&statusline, '')
endf

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" buftabs                                                                  "
"                                                                          "
" Copyright 2013 Jacek Szarski <jacek.szarski@gmail.com>                   "
" Copyright 2006 - 2011 Ico Doornekamp                                     "
"                                                                          "
" This file is part of buftabs, released under GNU General Public License, "
" please see LICENSE.md for details.                                       "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:Pecho=''
function! s:Pecho(msg)
  " Persistent echo to avoid overwriting of status line when 'hidden' is enabled
  if &ut!=1|let s:hold_ut=&ut|let &ut=1|en
  let s:Pecho=a:msg
  aug Pecho
    au CursorHold * if s:Pecho!=''|echo s:Pecho |let s:Pecho=''|let &ut=s:hold_ut|en |aug Pecho|exe 'au!'|aug END|aug! Pecho
  aug END
endf

function s:DrawInCommandLine(content)
  call s:Pecho(join(a:content, ' '))
endfunction

let g:buftabs_original_statusline = matchstr(&statusline, "%=.*")
function s:DrawInStatusline(content, current_index)
  let l:index = a:current_index - 1
  let l:markers = s:StatuslineMarkers()
  if (l:index < len(a:content)) && (l:index > -1)
    let a:content[l:index] = "\x01" . a:content[l:index] . "\x01"
    let l:outputs = split(' ' . join(a:content,'  ') . ' ', "\x01")
    let l:widths = s:CalculateOutputWidthsWithActive(strlen(l:outputs[0]), strlen(l:outputs[1]), strlen(l:outputs[2]))

    let s:output = l:markers[0] . strpart(l:outputs[0],strlen(l:outputs[0])-l:widths[0],l:widths[0])
    let s:output .=  l:markers[1] . l:outputs[1][:(l:widths[1])] . l:markers[2]
    let s:output .=  l:outputs[2][:(l:widths[2])] . l:markers[3]
  else
    let l:joined_content = ' ' . join(a:content, '  ') . ' '
    let l:width = s:CalculateOutputWidthWithoutActive(strlen(l:joined_content))
    let s:output = l:markers[0] . l:joined_content[:(l:width)] . l:markers[3]
  endif

  " If the statusline already includes %{g:BuftabsStatusline()},
  " only update the output, without overriding it.
  " Otherwise, override the whole statusline
  if match(&statusline, "%{g:BuftabsStatusline()}") == -1
    let &l:statusline = s:output . g:buftabs_original_statusline
  end
endfunction

function s:StatuslineMarkers()
  let l:active_suffix = ''
  let l:active_prefix = ''
  let l:list_prefix = ''
  let l:list_suffix = ''

  if g:BuftabsConfig('highlight_group','active') != ''
    let l:active_prefix = "%#" . g:BuftabsConfig('highlight_group','active')
    let l:active_prefix .= "#"
    let l:active_suffix = l:active_suffix . "%##"
  end

  if g:BuftabsConfig('highlight_group','inactive') != ''
    let l:list_prefix = '%#' . g:BuftabsConfig('highlight_group','inactive')
    let l:list_prefix .= '#'
    let l:list_suffix = '%##'
    let l:active_prefix = "%##" . l:active_prefix
    let l:active_suffix .= '%#' . g:BuftabsConfig('highlight_group','inactive')
    let l:active_suffix .= '#'
  end

  return [l:list_prefix, l:active_prefix, l:active_suffix, l:list_suffix]
endfunction


function s:CalculateOutputWidthWithoutActive(length)
  return min([winwidth(0) - 5,a:length])
endfunction

function s:CalculateOutputWidthsWithActive(length1, length2, length3)
  let l:width = s:CalculateOutputWidthWithoutActive(a:length1 + a:length2 + a:length3)
  let l:l2 = max([0,min([a:length2, l:width])])
  let l:l3 = max([0,min([a:length3, l:width - l:l2])])
  let l:l1 = max([0,min([a:length1, l:width - l:l2 - l:l3])])
  return [l:l1, l:l2, l:l3]
endfunction

function! g:BuftabsDisplay(content, current_index)
  " Show the list. The s:config['display']['statusline'] setting determines
  " if the list is displayed in the command line (volatile)
  " or in the statusline (persistent)

  if g:BuftabsConfig('display','statusline')
    call s:DrawInStatusline(a:content, a:current_index)
  else
    redraw
    call s:DrawInCommandLine(a:content)
  end
endfunction

function! g:BuftabsStatusline(...)
  " This is used when overwriting vim statusline
  return s:output
endfunction

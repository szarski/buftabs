"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" buftabs
"
" Copyright 2013 Jacek Szarski <jacek.szarski@gmail.com>
" Copyright 2006 - 2011 Ico Doornekamp
"
" This file is part of buftabs, released under GNU General Public License,
" please see LICENSE.md for details.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:buftabs_original_statusline = matchstr(&statusline, "%=.*")

let s:Pecho=''
function! s:Pecho(msg)
  " Persistent echo to avoid overwriting of status line when 'hidden' is enabled
  if &ut!=1|let s:hold_ut=&ut|let &ut=1|en
  let s:Pecho=a:msg
  aug Pecho
    au CursorHold * if s:Pecho!=''|echo s:Pecho |let s:Pecho=''|let &ut=s:hold_ut|en |aug Pecho|exe 'au!'|aug END|aug! Pecho
  aug END
endf

function s:DrawInStatusline(joined_content)
  let l:output = s:StatuslineMarkers()[0] . a:joined_content[0]
  if a:joined_content[1] != ''
    let l:output .= s:StatuslineMarkers()[1] . a:joined_content[1] . s:StatuslineMarkers()[2]
  endif
  let l:output .= a:joined_content[2] . s:StatuslineMarkers()[3]

  " Only overwrite the statusline if g:BuftabsStatusline() has not been
  " used to specify a location
  if match(&statusline, "%{g:BuftabsStatusline()}") == -1
    let &l:statusline = l:output . g:buftabs_original_statusline
  end
endfunction

function s:StatuslineMarkers()
  "if !exists('s:status_line_markers')
    let l:active_suffix = ''
    let l:active_prefix = ''
    let l:list_prefix = ''
    let l:list_suffix = ''

    if g:BuftabsConfig()['highlight_group']['active'] != ''
      let l:active_prefix = "%#" . g:BuftabsConfig()['highlight_group']['active'] . "#" . l:active_prefix
      let l:active_suffix = l:active_suffix . "%##"
    end

    if g:BuftabsConfig()['highlight_group']['inactive'] != ''
      let l:list_prefix = '%#' . g:BuftabsConfig()['highlight_group']['inactive'] . '#'
      let l:list_suffix = '%##'
      let l:active_prefix = "%##" . l:active_prefix
      let l:active_suffix = l:active_suffix . '%#' . g:BuftabsConfig()['highlight_group']['inactive'] . '#'
    end

    let s:status_line_markers = [l:list_prefix, l:active_prefix, l:active_suffix, l:list_suffix]
  "endif
  return s:status_line_markers
endfunction

function s:JoinedContent(content, current_index)
  let l:index = a:current_index - 1
  if (l:index < len(a:content)) && (l:index > -1)
    let l:output_before = l:index > 0 ? ' ' . join(a:content[0:(l:index - 1)], '  ') . ' ' : ''
    let l:output_after = l:index < len(a:content) - 1 ? ' ' . join(a:content[(l:index + 1):], '  ') . ' ' : ''
    let l:output_active = g:BuftabsConfig()['formatter_pattern']['start_marker'] . (a:content[l:index]) . g:BuftabsConfig()['formatter_pattern']['end_marker']

    let l:width = winwidth(0) - 5 - strlen(l:output_active)

    if strlen(l:output_after) > l:width
      let l:output_after = strpart(l:output_after, 0, l:width)
    endif

    let l:width -= strlen(l:output_after)

    if strlen(l:output_before) > l:width
      let l:output_before = strpart(l:output_before, strlen(l:output_before) - l:width , l:width)
    endif

    return [l:output_before, l:output_active, l:output_after]
  else
    let l:output = join(a:content, '  ')

    return [' ' . l:output,'',' ']
  endif
endfunction

function! g:BuftabsDisplay(content, current_index)
  " Show the list. The s:config['display']['statusline'] setting determines of the list
  " is displayed in the command line (volatile) or in the statusline
  " (persistent)

  let l:joined_content = s:JoinedContent(a:content, a:current_index)
  if g:BuftabsConfig()['display']['statusline']
    call s:DrawInStatusline(l:joined_content)
  else
    redraw
    call s:Pecho(l:joined_content[0] . l:joined_content[1] . l:joined_content[2])
  end
endfunction


"
" Optional function returning the current buftabs list string which can
" be used inside the statusline string using the %{g:BuftabsStatusline()}
" syntax
"

function! g:BuftabsStatusline(...)
	return s:list
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" buftabs                                                                  "
"                                                                          "
" Copyright 2013 Jacek Szarski <jacek.szarski@gmail.com>                   "
" Copyright 2006 - 2011 Ico Doornekamp                                     "
"                                                                          "
" This file is part of buftabs, released under GNU General Public License, "
" please see LICENSE.md for details.                                       "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if &diff                                      
  " Don't bother when in diff mode
  finish
endif     

function! s:ShowBuffer(index, deleted_buf)
  " Only show buffers in the list, and omit help screens
  return buflisted(a:index) && getbufvar(a:index, "&modifiable") && a:deleted_buf != a:index
endf

function! s:BufferActive(index)
  return winbufnr(winnr()) == a:index
endf

function! s:BufferModified(index)
  return getbufvar(a:index, "&modified") == 1
endf

function! s:BufferRepresentation(index)
  let l:name = g:FormatFileName(a:index)
  " Remove characters that mess up the statusline
  let l:name = substitute(l:name, "%", "%%", "g")

  if s:BufferModified(a:index)
    let l:name = l:name . g:BuftabsConfig('formatter_pattern','modified_marker')
  endif
  
  if s:BufferActive(a:index)
    let l:name = g:BuftabsConfig('formatter_pattern','start_marker') . l:name . g:BuftabsConfig('formatter_pattern','end_marker')
  endif

  return l:name
endf

function! g:Buftabs_show(deleted_buf)
  let l:list = []
  let l:current_index = -1

  " Walk the list of buffers
  for l:i in range(1,bufnr('$'))
    if s:ShowBuffer(l:i, a:deleted_buf)
      call add(l:list, s:BufferRepresentation(l:i))
      if s:BufferActive(l:i)
        let l:current_index = len(l:list)
      endif
    end
  endfor

  call g:BuftabsDisplay(l:list, l:current_index)
endfunction

" Hook to events to show buftabs at startup, when creating and when switching
" buffers

autocmd VimEnter,BufNew,BufEnter,BufWritePost * call g:Buftabs_show(-1)
autocmd BufDelete * call g:Buftabs_show(expand('<abuf>'))
if version >= 700
  autocmd InsertLeave,VimResized * call g:Buftabs_show(-1)
end

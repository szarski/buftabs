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

function! s:FullFileName(filename)
  return fnamemodify(a:filename, ":p")
endfunction

function! s:RootDirectory(filename)
  return FindRootDirectoryOfPath(s:FullFileName(a:filename))
endfunction

function! s:Tail(filename)
  return fnamemodify(a:filename, ":t")
endfunction

function! s:Head(filename)
  return fnamemodify(a:filename, ":h")
endfunction

function! s:PathWithoutRoot(filename)
  let l:full_name = s:FullFileName(a:filename)
  let l:root_dir = s:RootDirectory(a:filename)
  return substitute(l:full_name, l:root_dir . "/" , "", "")
endfunction

function! s:DirWithoutRoot(filename)
  let l:full_name = s:FullFileName(a:filename)
  return substitute(s:PathWithoutRoot(a:filename), s:Tail(l:full_name), "", "")
endfunction

function! s:FirstLettersOfDirs(filename)
  return substitute(a:filename, '\([^/]\)[^/]*', '\1', 'g')
endfunction

function! g:FormatFileName(bufnum)
  let l:filename = bufname(a:bufnum)
  let l:output = g:BuftabsConfig('formatter_pattern','normal')
  let l:root = s:RootDirectory(l:filename)

  let l:replace_list = [ ['\[bufnum\]', a:bufnum], ['\[bufname\]', l:filename], ['\[root_tail\]', s:Tail(l:root)], ['\[short_path_letters\]', s:FirstLettersOfDirs(s:DirWithoutRoot(l:filename))], ['\[filename\]', s:Tail(l:filename)] ]

  for [pattern, substitution] in l:replace_list
    if match(l:output, pattern) != -1
      let l:output = substitute(l:output, pattern, substitution, 'g')
    endif
  endfor

  return l:output
endfunction

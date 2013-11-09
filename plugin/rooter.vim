""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" buftabs                                                                  "
"                                                                          "
" Copyright 2013 Jacek Szarski <jacek.szarski@gmail.com>                   "
" Copyright 2006 - 2011 Ico Doornekamp                                     "
"                                                                          "
" This file is influenced by the great vim-rooter plugin                   "
" available with the MIT licence here:                                     "
" https://github.com/airblade/vim-rooter/blob/master/plugin/rooter.vim     "
"                                                                          "
" This file is part of buftabs, released under GNU General Public License, "
" please see LICENSE.md for details.                                       "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:patterns = ['.git/', '.git', '_darcs/', '.hg/', '.bzr/', '.svn/']

function! s:IsDirectory(pattern)
  return stridx(a:pattern, '/') != -1
endfunction

function! FindRootDirectoryOfPath(path)
  for l:pattern in s:patterns
    if s:IsDirectory(l:pattern)
      let match = finddir(l:pattern, a:path . ';')
      if !empty(match)
        return fnamemodify(match, ':p:h:h')
      endif
    else
      let match = findfile(l:pattern, a:path . ';')
      if !empty(match)
        return fnamemodify(match, ':p:h')
      endif
    endif
  endfor
  return ''
endfunction

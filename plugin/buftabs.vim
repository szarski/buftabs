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

"
" Don't bother when in diff mode
"

if &diff                                      
	finish
endif     


"
" Called on VimEnter event
"

function! Buftabs_enable()
	let w:buftabs_enabled = 1
endfunction

"
" Draw the buftabs
"

function! Buftabs_show(deleted_buf)
	let l:i = 1
	let s:list = []
	let l:current_index = 0

	if ! exists("w:buftabs_enabled")
		return
	endif

	" Walk the list of buffers

	while(l:i <= bufnr('$'))

		" Only show buffers in the list, and omit help screens
	
		if buflisted(l:i) && getbufvar(l:i, "&modifiable") && a:deleted_buf != l:i

			" Get the name of the current buffer, and escape characters that might
			" mess up the statusline

      let l:name = g:FormatFileName(g:BuftabsConfig()['formatter_pattern']['normal'], l:i)
			let l:name = substitute(l:name, "%", "%%", "g")

			if getbufvar(l:i, "&modified") == 1
				let l:name = l:name . g:BuftabsConfig()['formatter_pattern']['modified_marker']
			endif
			
			" Append the current buffer number and name to the list. If the buffer
			" is the active buffer, enclose it in some magick characters which will
			" be replaced by markers later. If it is modified, it is appended with
			" an appropriate symbol (an exclamation mark by default)

      call add(s:list,  l:name)

			if winbufnr(winnr()) == l:i
				let l:current_index = len(s:list)
			endif
		end

		let l:i = l:i + 1
	endwhile

	" If the resulting list is too long to fit on the screen, chop
	" out the appropriate part

  call g:BuftabsDisplay(s:list, l:current_index)

endfunction


"
" Hook to events to show buftabs at startup, when creating and when switching
" buffers
"

autocmd VimEnter,WinEnter * call Buftabs_enable()
autocmd VimEnter,BufNew,BufEnter,BufWritePost * call Buftabs_show(-1)
autocmd BufDelete * call Buftabs_show(expand('<abuf>'))
if version >= 700
	autocmd InsertLeave,VimResized * call Buftabs_show(-1)
end

" vi: ts=2 sw=2


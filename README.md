buftabs
=======

Introduction
------------

This plugin shows a tab-like list of buffers in the bottom of the window.
Because the list is displayed in the statusline or the commandline,
no additional windows or lines are used.

Installation
------------

I encourage using vundle (https://github.com/gmarik/vundle ):

```vimscript
Bundle 'szarski/buftabs'
```

Configuration
-------------

  * `g:buftabs_formatter_pattern`

    Set a pattern for displaying your buffer names.
    Patterns can be built using expressions:

      * `[bufnum]` - buffer number in vi
      * `[bufname]` - buffer name in vi
      * `[root_tail]` - highest directory name of the root
      * `[short_path_letters]` - first letters of the path after root 
      * `[filename]` - file name

    Example usage:
    ```vimscript
    let g:buftabs_formatter_pattern = '[root_tail]/[short_path_letters][filename]'
    ```

  * `g:buftabs_in_statusline`

    Define this variable to make the plugin show the buftabs in the statusline
    instead of the command line. It is a good idea to configure vim to show
    the statusline as well when only one window is open. Add to your .vimrc:

    ```vimscript
    let laststatus=2
    let g:buftabs_in_statusline=1
    ```
     
    By default buftabs will take up the whole of the left-aligned section of
    your statusline. You can alternatively specify precisely where it goes
    using `%{g:BuftabsStatusline()}` e.g.:

    ```vimscript
    let statusline=%=buffers:\ %{g:BuftabsStatusline()}
    ```

  * `g:buftabs_marker_start`
  * `g:buftabs_marker_end`

    Define to change the markers surrounging currently active buffer (or disable them by assigning empty strings).

    ```vimscript
    let g:buftabs_marker_start=''
    let g:buftabs_marker_end=''
    ```
  * `g:buftabs_marker_modified`

    Set the marker appended to modified buffers

    ```vimscript
    let g:buftabs_marker_modified='!!'
    ```
  * `g:buftabs_active_highlight_group`
  * `g:buftabs_inactive_highlight_group`
  * `g:buftabs_overflow_highlight_group`

    The name of a highlight group (:help highlight-groups) which is used to
    show:

      * the name of the current active buffer
      * all other inactive buffers
      * overflow markers

    If these variables are not defined, no highlighting is used.
    (Highlighting is only functional when g:buftabs_in_statusline is enabled)

    You can use your own highlight groups:

    ```vimscript
    hi BuftabsNormal  guifg=#D2FF2F guibg=Black
    hi BuftabsActive  guifg=#FFFFFF guibg=#2EE5FA
    hi BuftabsOverflow   guifg=#FFFFFF guibg=#FF0000

    let g:buftabs_active_highlight_group='BuftabsActive'
    let g:buftabs_inactive_highlight_group='BuftabsNormal'
    let g:buftabs_overflow_highlight_group='BuftabsOverflow'
    ```

Testing
-------

```bash
npm install coffee-script
npm install vimspec
vimspec
```

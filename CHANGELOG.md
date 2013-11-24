buftabs
=======

Changelog
---------

0.1   2006-09-22  Initial version 

0.2   2006-09-22  Better handling when the list of buffers is longer then the
                  window width.

0.3   2006-09-27  Some cleanups, set 'hidden' mode by default

0.4   2007-02-26  Don't draw buftabs until VimEnter event to avoid clutter at
                  startup in some circumstances

0.5   2007-02-26  Added option for showing only filenames without directories
                  in tabs

0.6   2007-03-04  'only_basename' changed to a global variable.  Removed
                  functions and add event handlers instead.  'hidden' mode 
                  broke some things, so is disabled now. Fixed documentation

0.7   2007-03-07  Added configuration option to show tabs in statusline
                  instead of cmdline

0.8   2007-04-02  Update buftabs when leaving insertmode

0.9   2007-08-22  Now compatible with older Vim versions < 7.0

0.10  2008-01-26  Added GPL license

0.11  2008-02-29  Added optional syntax highlighting to active buffer name

0.12  2009-03-18  Fixed support for split windows

0.13  2009-05-07  Store and reuse right-aligned part of original statusline

0.14  2010-01-28  Fixed bug that caused buftabs in command line being
                  overwritten when 'hidden' mode is enabled.

0.15  2010-02-16  Fixed window width handling bug which caused strange
                  behaviour in combination with the bufferlist plugin.
                  Fixed wrong buffer display when deleting last window.
                  Added extra options for tabs style and highlighting.

0.16  2010-02-28  Fixed bug causing errors when using buftabs in vim
                  diff mode.

0.17  2011-03-11  Changed persistent echo function to restore 'updatetime',
                  leading to better behaviour when showing buftabs in the
                  status line. (Thanks Alex Bradbury)

0.18  2011-03-12  Added marker for denoting modified buffers, provide
                  function for including buftabs into status line descriptor
                  instead of buftabs having to edit the status line directly.
                  (Thanks Andrew Ho)

s0.19 2013-09-05  Fixed some problems realted to variable scopes

s0.20 2013-10-12  Implemented buffer names custom formatting

s0.21 2013-11-01  Refactored settings and some parts of the main file,
                  updated readme a bit.

s0.22 2013-11-24  Refactored most of the plugin, improved tabs spacing
                  and overflow handling

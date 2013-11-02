exec 'source ' . getcwd() . '/plugin/config.vim'

function! SharedTestOfSettingWithDefaultValue(key1, key2, variable_name, default_value)
  call g:BuftabsResetConfig()
  call Describe("when " . a:variable_name . " is not set")
  exec 'unlet! ' . a:variable_name
  call AssertEquals(g:BuftabsConfig()[a:key1][a:key2], a:default_value)

  call g:BuftabsResetConfig()
  let l:test_value = 'test_value'
  call Describe("when " . a:variable_name . " is set to " . l:test_value)
  exec 'let ' . a:variable_name . ' = "' . l:test_value . '"'
  call AssertEquals(g:BuftabsConfig()[a:key1][a:key2], l:test_value)
endf

function! TestFormatterPatternNormal()
  call SharedTestOfSettingWithDefaultValue('formatter_pattern', 'normal', 'g:buftabs_formatter_pattern', '[bufnum]-[bufname]')
endf

function! TestFormatterPatternModifiedMarker()
  call SharedTestOfSettingWithDefaultValue('formatter_pattern', 'modified_marker', 'g:buftabs_marker_modified', '!')
endf

function! TestHighlihgtGroupActive()
  call SharedTestOfSettingWithDefaultValue('highlight_group', 'active', "g:buftabs_active_highlight_group", 0)
endf

function! TestHighlihgtGroupInactive()
  call SharedTestOfSettingWithDefaultValue('highlight_group', 'inactive', "g:buftabs_inactive_highlight_group", 0)
endf

function! TestDisplayStatusline()
  call SharedTestOfSettingWithDefaultValue('display', 'statusline', "g:buftabs_in_statusline", 0)
endf

function! TestFormatterPatternStartMarker()
  call SharedTestOfSettingWithDefaultValue('formatter_pattern', 'start_marker', 'g:buftabs_marker_start', "[")
endf

function! TestFormatterPatternEndMarker()
  call SharedTestOfSettingWithDefaultValue('formatter_pattern', 'end_marker', 'g:buftabs_marker_end', ']')
endf

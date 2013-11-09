function! s:GetSetting(group_name, setting_name)
  return s:config[a:group_name][a:setting_name]
endf

function! s:SetSetting(group_name, setting_name, value)
  if (!has_key(s:config, a:group_name))
    let s:config[a:group_name] = {}
  endif
  let s:config[a:group_name][a:setting_name] = a:value
endf

function! s:SetSettingFromVariable(group_name, setting_name, variable_name, default)
  if exists(a:variable_name) 
    let l:val = eval(a:variable_name)
  else
    let l:val = a:default
  endif
  call s:SetSetting(a:group_name, a:setting_name, l:val)
  return l:val
endf

function! s:GetBuftabsConfig()
  let s:config={}

  call s:SetSettingFromVariable('formatter_pattern', 'normal', "g:buftabs_formatter_pattern", "[bufnum]-[bufname]")

  call s:SetSettingFromVariable('formatter_pattern', 'modified_marker', "g:buftabs_marker_modified", "!")

  call s:SetSettingFromVariable('highlight_group', 'active', "g:buftabs_active_highlight_group", 0)

  call s:SetSettingFromVariable('highlight_group', 'inactive', "g:buftabs_inactive_highlight_group", 0)

  call s:SetSettingFromVariable('display', 'statusline', "g:buftabs_in_statusline", 0)

  call s:SetSettingFromVariable('formatter_pattern', 'start_marker', 'g:buftabs_marker_start', "[")

  call s:SetSettingFromVariable('formatter_pattern', 'end_marker', 'g:buftabs_marker_end', "]")

  return s:config
endf

function! g:BuftabsConfig(key1,key2)
  if !exists('g:buftabs_config')
    let g:buftabs_config = s:GetBuftabsConfig()
  endif
  return g:buftabs_config[a:key1][a:key2]
endf

function! g:BuftabsResetConfig()
  unlet! g:buftabs_config
endf

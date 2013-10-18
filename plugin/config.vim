function! s:GetSetting(group_name, setting_name)
  return s:config[a:group_name][a:setting_name]
endfunction

function! s:SetSetting(group_name, setting_name, value)
  if (!has_key(s:config, a:group_name))
    let s:config[a:group_name] = {}
  endif
  let s:config[a:group_name][a:setting_name] = a:value
endfunction

function! s:SetSettingFromVariable(group_name, setting_name, variable_name, default)
  if exists(a:variable_name) 
    let l:val = eval(a:variable_name)
  else
    let l:val = a:default
  endif
  call s:SetSetting(a:group_name, a:setting_name, l:val)
  return l:val
endfunction

function! g:GetBuftabsConfig()
  let s:config={}

  call s:SetSettingFromVariable('formatter_pattern', 'normal',
        \ "g:buftabs_formatter_pattern", "[bufnum]-[bufname]")

  call s:SetSettingFromVariable('formatter_pattern', 'modified_marker',
        \ "g:buftabs_marker_modified", "!")

  return s:config
endfunction
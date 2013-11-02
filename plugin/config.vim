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

  call s:SetSettingFromVariable('formatter_pattern', 'normal', "g:buftabs_formatter_pattern", "[bufnum]-[bufname]")

  call s:SetSettingFromVariable('formatter_pattern', 'modified_marker', "g:buftabs_marker_modified", "!")

  call s:SetSettingFromVariable('highlight_group', 'active', "g:buftabs_active_highlight_group", 0)

  call s:SetSettingFromVariable('highlight_group', 'inactive', "g:buftabs_inactive_highlight_group", 0)

  call s:SetSettingFromVariable('display', 'statusline', "g:buftabs_in_statusline", 0)

  call s:SetSettingFromVariable('formatter_pattern', 'start_marker', 'g:buftabs_marker_start', "[")

  call s:SetSettingFromVariable('formatter_pattern', 'end_marker', 'g:buftabs_marker_end', "]")

  let l:marker_end = s:GetSetting('formatter_pattern', 'end_marker')
  let l:marker_start = s:GetSetting('formatter_pattern', 'start_marker')
  let l:list_prefix = ''
  let l:list_suffix = ''

  if s:GetSetting('display', 'statusline')
    if s:GetSetting('highlight_group', 'active') != ''
      let l:marker_start = "%#" . s:GetSetting('highlight_group', 'active') . "#" . l:marker_start
      let l:marker_end = l:marker_end . "%##"
    end

    if s:GetSetting('highlight_group', 'inactive') != ''
      let l:list_prefix = '%#' . s:GetSetting('highlight_group', 'inactive') . '#'
      let l:list_suffix = '%##'
      let l:marker_start = "%##" . l:marker_start
      let l:marker_end = l:marker_end . '%#' . s:GetSetting('highlight_group', 'inactive') . '#'
    end
  end

  call s:SetSetting( 'formatter_pattern', 'active_prefix', l:marker_start)
  call s:SetSetting( 'formatter_pattern', 'active_suffix', l:marker_end)
  call s:SetSetting( 'formatter_pattern', 'list_prefix', l:list_prefix)
  call s:SetSetting( 'formatter_pattern', 'list_suffix', l:list_suffix)

  return s:config
endfunction

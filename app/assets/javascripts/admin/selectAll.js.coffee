jQuery ->
  $('#selectAll').click ->
    if @checked
      $(':checkbox').each ->
        @checked = true
        return
    else
      $(':checkbox').each ->
        @checked = false
        return
    return

@load = ->
  $(document).ready ->
    setMoney()
    random = []
    i = 0
    while i < workouts.length
      workout = workouts[i]
      random[i] =
        title: workout[0] + ': ' + workout[1] + '\n' + workout[6]
        start: workout[2]
        backgroundColor: workout[4]
        textColor: workout[3]
        borderColor: workout[5]
      i++
    $('#calendar').fullCalendar
      header:
        left: 'prev, today, next'
        center: 'title'
        right: ''
      viewDisplay: (view) ->
        cal_date_string = view.start.getMonth() + '/' + view.start.getFullYear()
        if cal_date_string == begin
          jQuery('.fc-button-prev').addClass 'fc-state-disabled'
        else
          jQuery('.fc-button-prev').removeClass 'fc-state-disabled'
        if cal_date_string == end
          jQuery('.fc-button-next').addClass 'fc-state-disabled'
        else
          jQuery('.fc-button-next').removeClass 'fc-state-disabled'
        return
      events: random
    return
  return

setMoney = ->
  document.getElementById('money_earned').innerHTML = amts[index]
  return

$('body').on 'click', 'span.fc-button.fc-button-today.fc-state-default.fc-corner-left.fc-corner-right.fc-state-hover', ->
  index = 0
  setMoney()
  return
$('body').on 'click', 'span.fc-button.fc-button-next.fc-state-default.fc-corner-left.fc-corner-right.fc-state-hover', ->
  if index > 0
    index -= 1
    setMoney()
  return
$('body').on 'click', 'span.fc-button.fc-button-prev.fc-state-default.fc-corner-left.fc-corner-right.fc-state-hover', ->
  if index < amts.length - 1
    index += 1
    setMoney()
  return
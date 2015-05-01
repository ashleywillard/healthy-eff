# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: https://jashkenas.github.com/coffee-script/

jQuery ->
  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    $('.remove_day').show()
    $('.remove_activity').show()
    $('.add_fields').show()
    event.preventDefault()

  $(document).ready ->
    $('.remove_day').show();
    $('.remove_activity').show();
    $('.add_fields').show();
    $(".activity.field").remove();
    $(".activity_link.add_fields").click();

  try $('.datepicker').datepicker({
        datesDisabled: $('.datepicker').data().dateDatesDisabled.split(",")
      })
  catch e

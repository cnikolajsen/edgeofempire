# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('#character_motivation_motivation_id').on 'change', ->
  $.ajax
    type: 'get'
    url: '/find/motivation_selection'
    data: 'motivation_id=' + $('#character_motivation_motivation_id').val()
    success: (data) ->
      $('#motivation-info').html(data)

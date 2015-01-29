# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('#character_obligation_obligation_id').on 'change', ->
  $.ajax(
    url: '/find/obligation_selection',
    data: 'obligation_id=' + $('#character_obligation_obligation_id').val()
  ).done (data) ->
    $('#obligation-info').html(data);

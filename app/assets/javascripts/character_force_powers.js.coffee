# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('#character_force_power_force_power_id').on 'change', ->
  $.ajax(
    url: '/find/force_power_selection',
    data: 'force_power_id=' + $('#character_force_power_force_power_id').val(),
    type: 'GET'
  ).success (data) ->
    $('#force-power-info').html(data);
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('#character_gears_gear_id').on 'change', ->
  $.ajax(
    url: '/find/equipment_selection',
    data: 'gear_id=' + $('#character_gears_gear_id').val(),
    type: 'GET'
  ).success (data) ->
    $('#item-info').html(data);

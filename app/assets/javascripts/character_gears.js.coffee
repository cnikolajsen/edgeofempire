# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('#character_gears_gear_id').select2()

$('#character_gears_gear_id').on 'select2:select', ->
  $.ajax(
    url: '/find/equipment_selection',
    data: 'gear_id=' + $('#character_gears_gear_id').val()
  ).done (data) ->
    $('#item-info').html(data)

$('#character_cybernetics_cybernetics_id').select2()

$('#character_cybernetics_cybernetics_id').on 'select2:select', ->
  $.ajax(
    url: '/find/equipment_selection',
    data: 'gear_id=' + $('#character_cybernetics_cybernetics_id').val()
  ).done (data) ->
    $('#item-info').html(data)

  $.ajax(
    url: '/find/cybernetics_locations',
    data: { id: $('#character_cybernetics_cybernetics_id').val() }
  ).success (data) ->
    $('#character_cybernetics_location').html('')
    for element in data
      $("#character_cybernetics_location").append($("<option></option>").val(element[1]).html(element[0]));

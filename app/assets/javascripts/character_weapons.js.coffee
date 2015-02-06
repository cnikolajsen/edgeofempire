# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('#character_weapons_weapon_id').select2()
$('#character_weapon_attachment_weapon_attachment_id').select2()

$('#character_weapons_weapon_id').on 'select2:select', ->
  $.ajax(
    url: '/find/weapon_selection',
    data: 'weapon_id=' + $('#character_weapons_weapon_id').val()
  ).done (data) ->
    $('#item-info').html(data);

$('#character_weapon_attachment_weapon_attachment_id').on 'select2:select', ->
  $.ajax(
    url: '/find/weapon_attachment_selection',
    data: 'attachment_id=' + $('#character_weapon_attachment_weapon_attachment_id').val()
  ).done (data) ->
    $('#attachment-info').html(data);

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('#character_armors_armor_id').on 'change', ->
  $.ajax(
    url: '/find/armor_selection',
    data: 'armor_id=' + $('#character_armors_armor_id').val()
  ).done (data) ->
    $('#item-info').html(data);

$('#character_armor_attachment_armor_attachment_id').on 'change', ->
  $.ajax(
    url: '/find/armor_attachment_selection',
    data: 'attachment_id=' + $('#character_armor_attachment_armor_attachment_id').val()
  ).done (data) ->
    $('#attachment-info').html(data);

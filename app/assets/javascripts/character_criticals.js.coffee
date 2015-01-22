# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('#character_criticals_effect').on 'change', ->
  $.ajax(url: "/ajax/criticals/" + encodeURIComponent($('#character_criticals_effect').val())).done (json) ->
    $('#character_criticals_description').val(json.criticals[0].description)
    $('#character_criticals_severity').val(json.criticals[0].severity)

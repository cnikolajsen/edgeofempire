# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('#character_career_id').on 'change', ->
  $.ajax(
    url: '/find/career_selection',
    data: 'career_id=' + $('#character_career_id').val()
  ).done (data) ->
    $('#career-info').html(data);

$('#character_race_id').on 'change', ->
  $.ajax(
    url: '/find/species_selection',
    data: 'species_id=' + $('#character_race_id').val()
  ).done (data) ->
    $('#species-info').html(data);

$('#character_strain').on 'change', ->
  $.ajax(
    url: $('#slug').val() +  '/strain/' + $('#character_strain').val()
    type: 'PATCH'
  ).success (data) ->
    $('.live-stats').effect('highlight', {}, 1000);

$('#character_wounds').on 'change', ->
  $.ajax(
    url: $('#slug').val() +  '/wound/' + $('#character_wounds').val()
    type: 'PATCH'
  ).success (data) ->
    $('.live-stats').effect('highlight', {}, 1000);

$('#character_credits').on 'change', ->
  $.ajax(
    url: $('#slug').val() +  '/money/' + $('#character_credits').val()
    type: 'PATCH'
  ).success (data) ->
    $('.live-stats').effect('highlight', {}, 1000);

$('#character_staggered').on 'change', ->
  $.ajax(
    url: $('#slug').val() +  '/stagger/' + $('#character_staggered').is(':checked'),
    type: 'PATCH'
  ).success (data) ->
    $('.live-stats').effect('highlight', {}, 1000);

$('#character_disoriented').on 'change', ->
  $.ajax(
    url: $('#slug').val() +  '/disorient/' + $('#character_disoriented').is(':checked'),
    type: 'PATCH'
  ).success (data) ->
    $('.live-stats').effect('highlight', {}, 1000);

$('#character_immobilized').on 'change', ->
  $.ajax(
    url: $('#slug').val() +  '/immobilize/' + $('#character_immobilized').is(':checked'),
    type: 'PATCH'
  ).success (data) ->
    $('.live-stats').effect('highlight', {}, 1000);

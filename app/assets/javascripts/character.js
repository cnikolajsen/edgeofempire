$('#character_armors_armor_id').change(function(){
  $.ajax({
    url: "/find/armor_selection",
    type: "GET",
    data: "armor_id="+$('#character_armors_armor_id').val(),
    success: function(data) {
      jQuery("#item-info").html(data);
    }
  })
});

$('#character_armor_attachment_armor_attachment_id').change(function(){
  $.ajax({
    url: "/find/armor_attachment_selection",
    type: "GET",
    data: "attachment_id="+$('#character_armor_attachment_armor_attachment_id').val(),
    success: function(data) {
      jQuery("#attachment-info").html(data);
    }
  })
});

$('#character_weapon_attachment_weapon_attachment_id').change(function(){
  $.ajax({
    url: "/find/weapon_attachment_selection",
    type: "GET",
    data: "attachment_id="+$('#character_weapon_attachment_weapon_attachment_id').val(),
    success: function(data) {
      jQuery("#attachment-info").html(data);
    }
  })
});

$('#character_weapons_weapon_id').change(function(){
  $.ajax({
    url: "/find/weapon_selection",
    type: "GET",
    data: "weapon_id="+$('#character_weapons_weapon_id').val(),
    success: function(data) {
      jQuery("#item-info").html(data);
    }
  })
});

$('#character_career_id').change(function(){
  $.ajax({
    url: "/find/career_selection",
    type: "GET",
    data: "career_id="+$('#character_career_id').val(),
    success: function(data) {
      jQuery("#career-info").html(data);
    }
  })
});

$('#character_race_id').change(function(){
  $.ajax({
    url: "/find/species_selection",
    type: "GET",
    data: "species_id="+$('#character_race_id').val(),
    success: function(data) {
      jQuery("#species-info").html(data);
    }
  })
});

$('#character_obligation_obligation_id').change(function(){
  $.ajax({
    url: "/find/obligation_selection",
    type: "GET",
    data: "obligation_id="+$('#character_obligation_obligation_id').val(),
    success: function(data) {
      jQuery("#obligation-info").html(data);
    }
  })
});

$('#character_motivation_motivation_id').change(function(){
  $.ajax({
    url: "/find/motivation_selection",
    type: "GET",
    data: "motivation_id="+$('#character_motivation_motivation_id').val(),
    success: function(data) {
      jQuery("#motivation-info").html(data);
    }
  })
});

$('#character_force_power_force_power_id').change(function(){
  $.ajax({
    url: "/find/force_power_selection",
    type: "GET",
    data: "force_power_id="+$('#character_force_power_force_power_id').val(),
    success: function(data) {
      jQuery("#force-power-info").html(data);
    }
  })
});

$('#character_gears_gear_id').change(function(){
  $.ajax({
    url: "/find/equipment_selection",
    type: "GET",
    data: "gear_id="+$('#character_gears_gear_id').val(),
    success: function(data) {
      jQuery("#item-info").html(data);
    }
  })
});

$('#character_strain').change(function(){
  $.ajax({
    url: $('#slug').val() +  '/strain/' + $('#character_strain').val(),
    type: 'PUT',
    success: function(data) {
      $('.live-stats').effect('highlight', {}, 1000);
    }
  });
});
$('#character_wounds').change(function(){
  $.ajax({
    url: $('#slug').val() +  '/wound/' + $('#character_wounds').val(),
    type: 'PUT',
    success: function(data) {
      $('.live-stats').effect('highlight', {}, 1000);
    }
  });
});
$('#character_staggered').change(function(){
  $.ajax({
    url: $('#slug').val() +  '/stagger/' + $('#character_staggered').is(':checked'),
    type: 'PUT',
    success: function(data) {
      $('.live-stats').effect('highlight', {}, 1000);
    }
  });
});
$('#character_disoriented').change(function(){
  $.ajax({
    url: $('#slug').val() +  '/disorient/' + $('#character_disoriented').is(':checked'),
    type: 'PUT',
    success: function(data) {
      $('.live-stats').effect('highlight', {}, 1000);
    }
  })
});
$('#character_immobilized').change(function(){
  $.ajax({
    url: $('#slug').val() +  '/immobilize/' + $('#character_immobilized').is(':checked'),
    type: 'PUT',
    success: function(data) {
      $('.live-stats').effect('highlight', {}, 1000);
    }
  })
});

function save_character_talent_option(character_id, element, tree, row, column, option) {
  $.ajax({
    url: "talents/" + tree + "/" + row + "/" + column + "/learn/" + option + "/" + element.value,
    type: "GET",
  });
}

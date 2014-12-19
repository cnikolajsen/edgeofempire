$('#character_armor_attachment_armor_attachment_id').change(function(){
  $.ajax({
    url: "/character/find/armor_attachment_selection",
    type: "GET",
    data: "attachment_id="+$('#character_armor_attachment_armor_attachment_id').val(),
    success: function(data) {
      jQuery("#attachment-info").html(data);
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

function save_character_talent_option(character_id, element, tree, row, column, option) {
  $.ajax({
    url: "talents/" + tree + "/" + row + "/" + column + "/learn/" + option + "/" + element.value,
    type: "GET",
  });
}

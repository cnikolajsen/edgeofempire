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
    url: "/character/find/career_selection",
    type: "GET",
    data: "career_id="+$('#character_career_id').val(),
    success: function(data) {
      jQuery("#career-info").html(data);
    }
  })
});

$('#character_race_id').change(function(){
  $.ajax({
    url: "/character/find/species_selection",
    type: "GET",
    data: "species_id="+$('#character_race_id').val(),
    success: function(data) {
      jQuery("#species-info").html(data);
    }
  })
});

$('#character_weapon_attachment_weapon_attachment_id').change(function(){
  $.ajax({
    url: "/character/find/weapon_attachment_selection",
    type: "GET",
    data: "attachment_id="+$('#character_weapon_attachment_weapon_attachment_id').val(),
    success: function(data) {
      jQuery("#attachment-info").html(data);
    }
  })
});

$('#character_obligation_obligation_id').change(function(){
  $.ajax({
    url: "/character/find/obligation_selection",
    type: "GET",
    data: "obligation_id="+$('#character_obligation_obligation_id').val(),
    success: function(data) {
      jQuery("#obligation-info").html(data);
    }
  })
});

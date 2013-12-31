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

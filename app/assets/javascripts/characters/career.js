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

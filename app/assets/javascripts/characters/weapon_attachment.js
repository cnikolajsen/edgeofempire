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
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
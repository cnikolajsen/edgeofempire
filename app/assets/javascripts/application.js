// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
// _require turbolinks
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require foundation
//= require cocoon
//= require footable.all.min
//= require select2/select2.min
//= require_tree .

// Place named functions here that do not fit into CoffeeScript.

$(function(){ $(document).foundation(); });

$(function () {
  $('.footable').footable();
});

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).before(content.replace(regexp, new_id));
}

function save_character_talent_option(character_id, element, tree, row, column, option) {
  $.ajax({
    url: "talents/" + tree + "/" + row + "/" + column + "/learn/" + option + "/" + element.value,
    type: "GET",
  });
}

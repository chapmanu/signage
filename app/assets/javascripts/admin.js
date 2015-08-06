/* VENDOR */
//= require jquery
//= require jquery_ujs
//= require turbolinks
Admin = {};

Admin.selectAllCheckboxes = function() {
  $('input[type="checkbox"]').prop('checked', true);
}

Admin.deselectAllCheckboxes = function() {
 $('input[type="checkbox"]').prop('checked', false);
}
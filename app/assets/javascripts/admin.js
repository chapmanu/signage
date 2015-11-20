/* VENDOR */
//= require jquery
//= require jquery_ujs
//= require jquery.datetimepicker
//= require jquery.sticky
//= require jquery-ui
//= require tinymce-jquery
//= require moment
//= require timeago
//= require selectize
//= require materialize-sprockets
//= require autocomplete-rails


/* APP */
//= require_self
//= require_tree ./shared
//= require_tree ./refills
//= require_tree ./admin

Admin = {};

/**
 *Fires on every single admin page
 */
$(document).on('ready', function(e) {
  //Fire all the stuff for the controllers
  var controller_action = $('body').data('controller-action');
  Utils.ready(controller_action);

  $('.js-sticky-slide-preview').sticky({topSpacing: 64});

  $('select').not('.disabled').material_select();
  $("abbr.timeago").timeago();
});
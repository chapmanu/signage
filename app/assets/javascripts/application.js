// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.

/* VENDOR */
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require owl.carousel
//= require moment
//= require jquery.scroll_into_view
//= require jquery.throttle_debounce

/* APPLICATION */
//= require utils
//= require_tree ./models
//= require devices
//= require slides

$(document).on('ready page:load', function(e){
  var controller_action = $('body').data('controller-action');
  Utils.ready(controller_action);
});
/* VENDOR */
//= require jquery
//= require jquery_ujs
//= require jquery.datetimepicker
//= require jquery.sticky
//= require jquery-ui
//= require materialize
//= require trix
//= require moment
//= require timeago
//= require selectize
//= require autocomplete-rails


/* APP */
//= require_self
//= require_tree ./shared
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


  $("abbr.timeago").timeago();
  
  $("[data-feedback]").on("click", function() {
    var message = $(this).data('feedback');
    $feedback = $("#feedback");
    $feedback.find('.message').text(message);
    $feedback.show();
  });

  //initialize dynamically added materialize select boxes
  $('select').not('.disabled').material_select();

  //prevents labels from overlapping text field values
  Materialize.updateTextFields();

  //initialize popup forms
  $('.modal').modal();

});
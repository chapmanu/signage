/* VENDOR */
//= require jquery
//= require jquery_ujs
//= require jquery.datetimepicker
//= require jquery.sticky
//= require moment
//= require tinymce-jquery
//= require turbolinks
//= require utils
//= require_tree ./refills

Date.parseDate = function( input, format ){
  return moment(input,format).toDate();
};
Date.prototype.dateFormat = function( format ){
  return moment(this).format(format);
};

Admin = {};

Admin.selectAllCheckboxes = function() {
  $('input[type="checkbox"]').prop('checked', true);
};

Admin.deselectAllCheckboxes = function() {
  $('input[type="checkbox"]').prop('checked', false);
};

Admin.refreshLivePreview = function() {
  $.post('/slides/live_preview', $("#slide_form").serialize(), function(data){
    tinymce.triggerSave();
    var iframe_doc = $('#slide-live-preview').contents()[0];
    iframe_doc.open();
    iframe_doc.write(data);
    iframe_doc.close();
  });
};

Utils.fireWhenReady(['slides#new', 'slides#edit'], function(e) {
  // Initialize all datetimepickers
  $('[data-datetimepicker]').datetimepicker({
    format:'MMMM DD, YYYY h:mm a',
    formatTime:'h:mm a',
    formatDate:'DD.MM.YYYY'
  });

  // Show hide fields conditionally
  $('[data-show-when]').each(function(i, val) {
    var $this   = $(this);
    var info    = $(this).data('show-when').split('==');
    var $el     = $(info[0]);
    var pattern = new RegExp(info[1]);

    var listener = function() {
      var val = $el.val();
      (pattern.test(val)) ? $this.show() : $this.hide();
    };

    $el.on('change', listener);
    listener();
  });

  // Stick slide preview
  $('.js-sticky-slide-preview').sticky({topSpacing: 64});

  // List for all form change events
  Admin.refreshLivePreview();
  $('#slide_form :input').on('change', Admin.refreshLivePreview);
});


// DOCUMENT READY
$(document).on('ready page:load', function(e){
  // Fire all the stuff for the controllers
  var controller_action = $('body').data('controller-action');
  Utils.ready(controller_action);
});
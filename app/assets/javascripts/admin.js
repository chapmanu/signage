/* VENDOR */
//= require jquery
//= require jquery_ujs
//= require jquery.datetimepicker
//= require moment
//= require tinymce-jquery
//= require turbolinks
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
}

Admin.deselectAllCheckboxes = function() {
  $('input[type="checkbox"]').prop('checked', false);
}

$(document).on('ready page:load', function() {

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
});
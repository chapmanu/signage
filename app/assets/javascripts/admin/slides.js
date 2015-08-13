/**
 * Setting up the namespace
 */
Admin.Slides = {};

/**
 * Functions specific to slides on the administration views
 */

Admin.Slides.livePreviewAjax = function() {
  var form_data = new FormData($('#slide_form')[0]);
  $.ajax({
      url:        '/slides/live_preview',
      type:       'POST',
      data:        form_data,
      success:     Admin.Slides.livePreviewSuccess,
      error:       Admin.Slides.livePreviewError,
      cache:       false,
      contentType: false,
      processData: false
  });
};

Admin.Slides.livePreviewSuccess = function(data) {
  var iframe_doc = $('#slide-live-preview').contents()[0];
  iframe_doc.open();
  iframe_doc.write(data);
  iframe_doc.close();
};

Admin.Slides.livePreivewError = function(error) {
  console.log(error);
};

Admin.Slides.initDateTimePickers = function() {
  $('[data-datetimepicker]').datetimepicker({
    format:'MMMM DD, YYYY h:mm a',
    formatTime:'h:mm a',
    formatDate:'DD.MM.YYYY'
  });
};

Admin.Slides.initShowWhen = function() {
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
};

Admin.Slides.initLivePreview = function() {
  Admin.Slides.livePreviewAjax();
  $('#slide_form :input').on('change', Admin.Slides.livePreviewAjax);
};


/**
 * The code that runs on document.ready
 */

Utils.fireWhenReady(['slides#new', 'slides#edit'], function(e) {
  Admin.Slides.initDateTimePickers();
  Admin.Slides.initShowWhen();
  Admin.Slides.initLivePreview();
});
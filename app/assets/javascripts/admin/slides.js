/**
 * Setting up the namespace
 */
Admin.Slides = {};

/**
 * Functions specific to slides on the administration views
 */

Admin.Slides.livePreviewAjax = function() {
  if (!Admin.Slides.currently_ajaxing) {
    Admin.Slides.currently_ajaxing  = true;
    var form_data = new FormData($('#slide_form')[0]);
    $.ajax({
        url:        '/slides/live_preview',
        type:       'POST',
        data:        form_data,
        success:     Admin.Slides.livePreviewSuccess,
        error:       Admin.Slides.livePreviewError,
        complete:    Admin.Slides.livePreviewComplete,
        cache:       false,
        contentType: false,
        processData: false
    });
  }
};

Admin.Slides.livePreviewSuccess = function(data) {
  var iframe_doc = $('#slide-live-preview').contents()[0];
  iframe_doc.open();
  iframe_doc.write(data);
  iframe_doc.close();
  setTimeout(function() {
    $(iframe_doc.body).hide();
    $(iframe_doc.body).show(300);
  }, 100);
};

Admin.Slides.livePreivewError = function(error) {
  // Should one need to do something here, here it is.
};

Admin.Slides.livePreviewComplete = function(data) {
  Admin.Slides.currently_ajaxing = false;
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
  $('#slide_template').on('change', function() {
    Admin.Slides.livePreviewAjax();
    $('.js-sticky-slide-preview').sticky('update');
  });
  Admin.Slides.livePreviewAjax();
};

Admin.Slides.initTinyMCE = function() {
  tinyMCE.init({
    menubar:        false,
    content_style: 'p { font-size: 16px; }',
    selector:      '.tinymce',
    setup: function (editor) {
      editor.on('blur', function () {
        tinyMCE.triggerSave();
        $('textarea.tinymce').trigger('change');
      });
    }
  });
};


/**
 * The code that runs on document.ready
 */

Utils.fireWhenReady(['slides#new', 'slides#edit'], function(e) {
  Admin.Slides.initDateTimePickers();
  Admin.Slides.initShowWhen();
  tinyMCE.remove();
  Admin.Slides.initLivePreview();
  Admin.Slides.initTinyMCE();
});

$(document).on('dynamic_fields_added', function($fields) {
  Admin.Slides.initTinyMCE();
  Admin.Slides.initDateTimePickers();
});

Utils.fireWhenReady(['slides#index'], function(e) {
  $('html').on('click', function() {
    $('.js-admin-slide.selected').removeClass('selected');
  });

  $('.js-admin-slide').on('click', function(e) {
    e.stopPropagation();
    if ($(this).hasClass('selected')) {
      $(this).removeClass('selected');
    } else {
      $('.js-admin-slide.selected').removeClass('selected');
      $(this).addClass('selected');
    }
  });
});
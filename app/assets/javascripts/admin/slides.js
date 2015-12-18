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
      var val;
      if ($el.prop('type') === 'radio') {
        val = $($el.selector + ':checked').val();
      } else {
        val = $el.val();
      }
      (pattern.test(val)) ? $this.fadeIn(250) : $this.hide();
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
  $(':input, :checkbox, :radio').on('blur', function() {
    Admin.Slides.livePreviewAjax();
  });
  Admin.Slides.livePreviewAjax();
};

/* Index Page */
var AdminSlides = {};

AdminSlides.refreshList = function(e) {
  var search   = $('#search').val();
  var filter   = $('#filters .active').data('value');
  var sort     = $('#sort .active').data('value');
  var query    = '?search='+search+'&filter='+filter+'&sort='+sort;
  $.get('/slides.js' + encodeURI(query) );
};

AdminSlides.filterClicked = function(e) {
  e.preventDefault();
  $(this).parent().find('a').removeClass('active');
  $(this).addClass('active');
  var filter   = $('#filters .active').data('value');
  var sort     = $('#sort .active').data('value');
  var query    = '?filter='+filter+'&sort='+sort;
  var url      = window.location.pathname + query;
  window.history.replaceState({path:url},'',url);
  AdminSlides.refreshList();
};

AdminSlides.initSlideActionMenus = function() {
  $('.modal-trigger').leanModal();
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
};


/**
 * The code that runs on document.ready
 */

Utils.fireWhenReady(['slides#new', 'slides#create', 'slides#edit', 'slides#update'], function(e) {
  Admin.Slides.initDateTimePickers();
  Admin.Slides.initShowWhen();
  Admin.Slides.initLivePreview();
  $('.datepicker').pickadate();
});

$(document).on('dynamic_fields_added', function(event, $fields) {
  Admin.Slides.initDateTimePickers();
  $fields.find('select').not('.disabled').material_select();
  $fields.find('.datepicker').pickadate();
});

Utils.fireWhenReady(['slides#index'], function(e) {
  AdminSlides.initSlideActionMenus();
  $('#search').on('keyup', AdminSlides.refreshList);
  $('#filters a, #sort a').on('click', AdminSlides.filterClicked);
});

Utils.fireWhenReady(['slides#show'], function() {
  $('.modal-trigger').leanModal();
});
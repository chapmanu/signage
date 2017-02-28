Utils.fireWhenReady(['slides#preview'], function(e) {
  // Product owners provided these values. They are our standard monitors dimensions.
  var STD_LONG_DIM = 1920;
  var STD_SHORT_DIM = 1080;

  // Scale the view to the size it will need to display
  var $uiFeed = $('.ui-feed');
  var isVertical = $uiFeed.find(".js-slide-meta").data("orientation") === "vertical" ? true : false;
  var stdWidth = isVertical? STD_SHORT_DIM : STD_LONG_DIM;
  var stdHeight = isVertical? STD_LONG_DIM : STD_SHORT_DIM;

  $('.ui-feed').css({width: stdWidth, height: stdHeight});

  // Scale the slide on resize
  var scaleSlidePreview = $.throttle(50, function() {
    var
    scale_x = Math.min(window.innerWidth / stdWidth, 1),
    scale_y = Math.min(window.innerHeight / stdHeight, 1),
    scale   = Math.min(scale_x, scale_y);
    if (window.innerWidth <= 1760) {
      $('.ui-feed').css('transform', 'scale('+scale+')');
    } else {
      $('.ui-feed').css('transform', '');
    }
  });
  scaleSlidePreview();
  $(window).on('resize', scaleSlidePreview);

  // Run the javascript need to play this slide
  new Slide($('.ui-feed--preview')).play();
});
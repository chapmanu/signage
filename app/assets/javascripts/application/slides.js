Utils.fireWhenReady(['slides#preview'], function(e) {
  // Scale the view to the size it will need to display
  $('.ui-feed').css({width: '1920px', height: '1080px'});

  // Scale the slide on resize
  var scaleSlidePreview = $.throttle(50, function() {
    var
    scale_x = Math.min(window.innerWidth / 1920, 1),
    scale_y = Math.min(window.innerHeight / 1080, 1),
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
Utils.fireWhenReady(['slides#show'], function(e) {
  $('.ui-feed').css({width: '1920px', height: '1080px'});
  var scaleSlidePreview = $.throttle(50, function() {
    var
    scale_x = Math.min(window.innerWidth / 1920, 1),
    scale_y = Math.min(window.innerHeight / 1080, 1),
    scale   = Math.min(scale_x, scale_y);
    if (window.innerWidth <= 1760) {
      console.log('need to scale');
      $('.ui-feed').css('transform', 'scale('+scale+')');
    } else {
      $('.ui-feed').css('transform', '');
    }
  });
  scaleSlidePreview();
  $(window).on('resize', scaleSlidePreview);
});
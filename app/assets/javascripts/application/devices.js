Utils.fireWhenReady(['signs#play'], function(e) {
  var footer = $('footer#js-organizer');
  var footerHeightRatio = footer.hasClass('vertical') ? .85 : .75;

  Device.initialize({
    menu: $('.ui-menu-list'),
    slides: $('main')
  });

  Device.play();

  // Listen for 5 clicks on the chapman Logo
  $('#chapman-logo').on('click', function(event) {
    if (event.originalEvent.detail === 5) { window.location = Device.meta('edit-url'); }
  });

  // Listen for page load/resize to position the organizer footer
  $(window).on('load resize', function() {
    footer.css('top', ($(window).height() * footerHeightRatio));
  });
});
Utils.fireWhenReady(['devices#play'], function(e) {
  Device.initialize({
    menu: $('.ui-menu-list'),
    slides: $('main')
  });

  Device.play();

  // Listen for 5 clicks on the chapman Logo
  $('#chapman-logo').on('click', function(event) {
    if (event.originalEvent.detail === 5) { window.location = '/devices'; }
  });
});
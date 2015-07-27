// HELPER FUNCTIONS
function updateTime() {
  $('.ui-location-time').text(moment().format("dddd, MMMM Do YYYY, h:mm:ss a"));
}

function onMultiLogoClick(event) {
  if (event.originalEvent.detail === 5) { window.location = '/devices'; }
}

function updateMenu($menu, position) {
  $menu.trigger('to.owl.carousel', position);
  $menu.find('.ui-menu-item--active').removeClass('ui-menu-item--active');
  $menu.find('.owl-item.center').addClass('ui-menu-item--active');
}

$(document).on('ready page:load', function() {
  // Select your dom nodes
  var $menu = $('.ui-menu-list');
  var $main = $('main')

  // Get the current time going.
  updateTime();
  setInterval(updateTime, 1000);

  // Listen for 5 clicks on the chapman Logo
  $('#chapman-logo').on('click', onMultiLogoClick);

  // Initialize the Menu Carousel
  $menu.owlCarousel({
    center:    true,
    autoWidth: true,
  });

  // Initialize the Main Carousel
  $main.owlCarousel({
    animateOut: 'slideOutDown',
    animateIn:  'flipInX',

    // animateOut: 'slideOutDown',
    // animateIn:  'zoomIn',

    // animateOut: 'rollOut',
    // animateIn:  'rollIn',

    // animateOut: 'fadeOutDown',
    // animateIn:  'fadeInDown',
    items: 1,
    URLhashListener: true,
    autoplay: true,
    onInitialized: function(evt) { updateMenu($menu, this._current); }
  });

  // Update menu when main carousel changes
  $main.on('changed.owl.carousel', function(evt) { updateMenu($menu, evt.item.index); });
});
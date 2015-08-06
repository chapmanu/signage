/**
 * The Device object contains the logic to play the slide.
 *
 * All devices must be initialized with:
 *  slides [OWL CAROUSEL]
 *  menu   [OWL CAROUSEL]
 */
window.Device = {
  slides: undefined,
  menu:   undefined,
  emergency_poll_interval: 5000
};

/**
 * PUBLIC INTERFACE
 */

Device.initialize = function(config) {
  if (!config.menu)   console.error('Need to pass in {menu: $element}');
  if (!config.slides) console.error('Need to pass in {slides: $element}');
  Device._initializeMenu(config.menu);
  Device._initializeSlides(config.slides);
  Device._startClock();
  Device._refreshMenu();
  Device._startPolling();
}

Device.play = function() {
  Device.currentSlide().play();
  Device._queueNextSlide();
};

Device.stop = function() {
  Device.currentSlide().stop();
  clearTimeout(Device.timeout_id)
}

Device.nextIndex = function() {
  var i = Device.currentIndex();
  return (i < Device.owl_slides._items.length - 1) ? (i + 1) : 0;
};

Device.currentSlide = function() {
  return this.slides[this.currentIndex()];
};

Device.currentIndex = function() {
  return this.owl_slides._current;
};

Device.meta = function(key) {
  return $('.js-device-meta').data(key);
}

/**
 * PRIVATE (Don't rely on these methods outside this file)
 */

Device._initializeMenu = function(menu) {
  menu.owlCarousel({
    center:    true,
    autoWidth: true,
    onInitialized: function(evt) {
      Device.owl_menu = this;
    }
  });
};

Device._initializeSlides = function(slides) {
  var owl = slides.owlCarousel({
    animateOut: 'fadeOutDown',
    animateIn:  'fadeInDown',
    items: 1,
    URLhashListener: true,
    onInitialized: function(evt) {
      Device.owl_slides = this;
      Device.slides = $.map(this._items, function(item) { return new Slide(item) });
    }
  });
  owl.on('change.owl.carousel', function(evt) {
    Device.stop();
  })

  owl.on('changed.owl.carousel', function(evt) {
    Device._refreshMenu();
    Device.play();
  });
}

Device._refreshMenu = function() {
  Device.owl_menu.$element.trigger('to.owl.carousel', this.currentIndex());
  Device.owl_menu.$element.find('.ui-menu-item--active').removeClass('ui-menu-item--active');
  Device.owl_menu.$element.find('.owl-item.center').addClass('ui-menu-item--active');
};

Device._startClock = function() {
  this._updateTime();
  return setInterval(this._updateTime, 1000);
};

Device._updateTime = function() {
  $('.ui-location-time').text(moment().format("dddd, MMMM Do YYYY, h:mm:ss a"));
};

Device._queueNextSlide = function() {
  clearTimeout(Device.timeout_id);
  Device.timeout_id = setTimeout(function() {
    Device.owl_slides.to(Device.nextIndex());
  }, Device.currentSlide().meta('duration') * 1000);
};

Device._startPolling = function() {
  var path = Device.meta('poll-device-path');
  var data = { device: {updated_at: Device.meta('updated-at')}};
  setInterval(function() {
    $.get(path, data);
  }, Device.emergency_poll_interval);
}

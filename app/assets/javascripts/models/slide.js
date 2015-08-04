var Slide = function($element) {
  this.$element = $element;
  if (/directory/.test(this.meta('layout')) ) {
    this.behaviors = [
    $.extend({}, autoscrollable, {
      container:        '.ui-slide-collection',
      items:            '.ui-member',
      visible_rows:    4,
      items_per_row:   4,
      rows_per_scroll: 2,
      scroll_interval: 8000
    })
  ];
  } else {
    this.behaviors = []
  }
  var self = this;
  $.each(this.behaviors, function(i, behavior) { behavior.initialize(self); });
};

Slide.prototype.play = function() {
  $.each(this.behaviors, function(i, behavior) {
    behavior.play();
  });
};

Slide.prototype.stop = function() {
  $.each(this.behaviors, function(i, behavior) {
    behavior.stop();
  });
};

Slide.prototype.meta = function(key) {
  return this.$element.find('.js-slide-meta').data(key);
};
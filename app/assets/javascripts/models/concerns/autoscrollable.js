var autoscrollable = {

  /**
   * Public configuration
   */

  container:       null,
  items:           null,
  visible_rows:    null,
  items_per_row:   null,
  rows_per_scroll: null,
  scroll_interval: null,

  /**
   * Public Methods
   */

  initialize: function(slide) {
    this.$container = slide.$element.find(this.container);
    this.$items     = this.$container.find(this.items);
  },

  play: function() {
    var current_index = 0;
    this._scrollToItem(current_index);

    var self = this;
    this.interval_id = setInterval(function() {
      if (self._reachedEnd(current_index)) {
        current_index = 0;
      } else {
        current_index += self.rows_per_scroll * self.items_per_row;
      }
      self._scrollToItem(current_index);
    }, self.scroll_interval);
  },

  stop: function() {
    clearInterval(this.interval_id);
  },

  /**
   * Private
   */

  _scrollToItem: function(index) {
    var $child = this.$container.find(this.items).eq(index);
    this.$container.animate({
      scrollTop: $child.offset().top - this.$container.offset().top + this.$container.scrollTop()
    });
  },

  _reachedEnd: function(visible_index) {
    var last_index = (visible_index + (this.visible_rows * this.items_per_row));
    return last_index >= (this.$items.length - 1)
  }

};
// A directory slide

var Slide = function($element) {
  this.$element = $element;
};

Slide.prototype.play = function() {
  var $scrollable = this.$element.find('.ui-slide-collection-inset');

  var visible_rows    = 5;
  var items_per_row   = 4;
  var rows_per_scroll = 1;
  var current_index   = (visible_rows * items_per_row);

  if ($scrollable.length) {
    setInterval(function() {
      current_index += (rows_per_scroll * items_per_row);

      if (current_index >= $scrollable.children().length) {
        $scrollable.children().eq(0).scrollIntoView();
        current_index = visible_rows * items_per_row;
        console.log('Just scrolled back to 0');
      } else {
        $scrollable.children().eq(current_index - 1).scrollIntoView();
        console.log('Scrolled to ', current_index);
      }


    }, 2000);
  }
};
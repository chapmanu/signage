Admin.Devices = {};

Admin.Devices.editors_container = '#js-device-editors-container';
Admin.Devices.sortable_slides   = '#js-sortable-slides';

Admin.Devices.updateSlideOrder = function(event, ui) {
  var ids = $(Admin.Devices.sortable_slides).sortable('serialize');
  $.post($('#js-device-meta').data('sort-path'), ids);
};

Admin.Devices.updateEditorsTable = function(html) {
  $(Admin.Devices.editors_container).html(html);
};

Utils.fireWhenReady(['devices#edit', 'devices#update'], function(e) {
  $('#user_id').selectize({
      sortField: 'text',
      load: function(query, callback) {
        if (!query.length) return callback();
        console.log('sup')
      }
  });

  $('#js-sortable-slides').sortable({
    update: Admin.Devices.updateSlideOrder,
    containment: 'parent',
    tolerance: 'pointer'
  });
});
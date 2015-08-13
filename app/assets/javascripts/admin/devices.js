Admin.Devices = {};

Admin.Devices.updateSlideOrder = function(event, ui) {
  var ids = $('#js-sortable-slides').sortable('serialize');
  $.post($('#js-device-meta').data('sort-path'), ids);
};

Utils.fireWhenReady(['devices#edit', 'devices#update'], function(e) {
  $('#js-sortable-slides').sortable({
    update: Admin.Devices.updateSlideOrder,
    containment: 'parent',
    tolerance: 'pointer',
    revert: 150
  });
});
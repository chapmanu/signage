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

Admin.selectizeUserFormat = function (user) {
  return {
    text: user.first_name + ' ' + user.last_name + ' ('+ user.email +')',
    value: user.id
  }
};

Utils.fireWhenReady(['devices#settings'], function(e) {
  $('#user_id').selectize({
      sortField: 'text',
      load: function(query, callback) {
        if (!query.length) return callback();
        $.get('/users/lookup.json?username='+query, function(item) { callback([Admin.selectizeUserFormat(item)]); });
      }
  });
});

Utils.fireWhenReady(['devices#show'], function(e) {
  $('#js-sortable-slides').sortable({
    update: Admin.Devices.updateSlideOrder,
    containment: 'parent',
    tolerance: 'pointer'
  });
});

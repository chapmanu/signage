Admin.Devices = {};

Admin.Devices.editors_container = '#js-device-editors-container';
Admin.Devices.sortable_slides   = '#js-sortable-slides';

Admin.Devices.updateSlideOrder = function(event, ui) {

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

Utils.fireWhenReady(['signs#settings'], function(e) {
  $('#user_id').selectize({
      sortField: 'text',
      load: function(query, callback) {
        if (!query.length) return callback();
        $.get('/users/lookup.json?username='+query, function(item) { callback([Admin.selectizeUserFormat(item)]); });
      }
  });
});

;

/* New */

var AdminSigns = {};

AdminSigns.updateSlideOrder = function() {
  var ids = $('#js-sortable-slides').sortable('serialize');
  $.post($('#js-sign-meta').data('sort-path'), ids);
};

AdminSigns.refreshList = function(e) {
  var search   = $('#search').val();
  var filter   = $('#filter-mine').hasClass('active') ? 'mine' : 'all';
  var query    = '?search='+search+'&filter='+filter;
  $.get(location.pathname + '.js' + encodeURI(query) );
};

AdminSigns.filterClicked = function(e) {
  e.preventDefault();
  $('#signs-filters a').removeClass('active');
  $(this).addClass('active');
  var url = window.location.pathname+'?filter='+$(this).data('value');
  window.history.replaceState({path:url},'',url);
  AdminSigns.refreshList();
};

/* ON READY EVENTS */

Utils.fireWhenReady(['signs#index'], function(e) {
  $('#search').on('keyup', AdminSigns.refreshList);
  $('#signs-filters a').on('click', AdminSigns.filterClicked);
});

Utils.fireWhenReady(['signs#show', 'signs#edit', 'signs#update'], function(e) {
  $('#js-sortable-slides').sortable({
    update: AdminSigns.updateSlideOrder,
    tolerance: 'pointer'
  });
})
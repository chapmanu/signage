Admin.Devices = {};

Admin.Devices.editors_container = '#js-device-editors-container';
Admin.Devices.sortable_slides   = '#js-sortable-slides';

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


/**
 *  Ugly Temporary Add Owner Callback
 *  This is a temporary fix to allow users to add owners to slides. The issue is connected to the jQuery autocomplete not working.
 *  See GitHub issue: https://github.com/chapmanu/signage/issues/183
 *  There is believed to be a naming conflict with jQuery autocomplete and the Materialize autocomplete function that was added in version 0.98.0
 *  This fix may be able to be removed when Materialize fixes the naming issue on their end.
 *  The same uglyTempAddOwnerCallback function is used in signs.js
 */
AdminSigns.uglyTempAddOwnerCallback = function(e) {
  $('#add_owner').on('click', function(e) {

    // stop all
    e.preventDefault();

    var user = $('#search_users').val();

    $.ajax({
      url: '/signs/autocomplete_user_email?term=' + user,
      type: "GET",
    }).done(function(returnedData) {
      // if returnedData not null
      if($.trim(returnedData)){
        returnedData.forEach(function(element) {

          //check for exact match email, exclude partials
          if(element.email === user){
            $('input#user_id').val(element.id);
            $("#add_owner").submit();
          }
        });
      }
      else{
        Materialize.toast("User "+ user +" could not be found", 4000)
      }
    });

  });
}

AdminSigns.updateSlideOrder = function() {
  var ids = $('#js-sortable-slides').sortable('serialize');
  $.post($('#js-sign-meta').data('sort-path'), ids);
};

AdminSigns.refreshList = function(e) {
  var search   = $('#search').val();
  var filter   = $('#filters .active').data('value');
  var query    = '?search='+search+'&filter='+filter;
  $.get('/signs.js' + encodeURI(query) );
};

AdminSigns.filterClicked = function(e) {
  e.preventDefault();
  $('#filters a').removeClass('active');
  $(this).addClass('active');
  var url = window.location.pathname+'?filter='+$(this).data('value');
  window.history.replaceState({path:url},'',url);
  AdminSigns.refreshList();
};

/* ON READY EVENTS */

Utils.fireWhenReady(['signs#index'], function(e) {
  $('#search').on('keyup', AdminSigns.refreshList);
  $('#filters a').on('click', AdminSigns.filterClicked);
});

Utils.fireWhenReady(['signs#show', 'signs#edit', 'signs#update'], function(e) {
  AdminSigns.uglyTempAddOwnerCallback();
  $('#js-sortable-slides').sortable({
    update: AdminSigns.updateSlideOrder,
    tolerance: 'pointer'
  });
  $('.modal-trigger').modal();
})
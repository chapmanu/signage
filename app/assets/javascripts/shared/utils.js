Utils = {};

/**
 * If value is undefined, return default value, otherwise, return the value
 *
 * @param value [Anything]
 * @param default_value [Anything]
 * @return [Anything]
 */
Utils.fetch = function(value, default_value) {
  return (typeof value !== 'undefined') ? value : default_value;
};


Utils.ready_callbacks = {};

/**
 * Use this to load up read functions for certain actions
 */
Utils.fireWhenReady = function(controller_actions, callback) {
  $.each(controller_actions, function(i, controller_action) {
    if ($.isArray( Utils.ready_callbacks[controller_action] )) {
      Utils.ready_callbacks[controller_action].push(callback);
    } else {
      Utils.ready_callbacks[controller_action] = [callback];
    }
  });
};

/**
 * Use this to fire all the readies for a particular view
 */
Utils.ready = function(controller_action, e) {
  if (Utils.ready_callbacks[controller_action]) {
    $.each(Utils.ready_callbacks[controller_action], function(i, callback) {
      callback(e);
    });
  }
};

/**
 * Check all checkboxes on a page
 */
Utils.selectAllCheckboxes = function() {
  $('input[type="checkbox"]').prop('checked', true);
};

/**
 * Deselect all checkboxes on a page
 */
Utils.deselectAllCheckboxes = function() {
  $('input[type="checkbox"]').prop('checked', false);
};

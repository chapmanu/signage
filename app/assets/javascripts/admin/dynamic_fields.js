/*
 * This javascript is used when you have a has_many resource and you want
 * to add or remove those nested resources from the parent.  This, along
 * with some rails helpers lets you do just that.
 */
function setDynamicFieldIDs(fields) {
  var new_id  = new Date().getTime(),
      regexp  = new RegExp("new_dynamic_fields", "g");

  return fields.replace(regexp, new_id);
}

$(document).on('click', '[data-behavior="remove-dynamic-fields"]', function(e) {
 e.preventDefault();
 $(this).prev("input[type=hidden]").val("1");
 $(this).parents('[data-behavior="dynamic-fields"]').hide();
});

$(document).on('click', '[data-behavior="add-dynamic-fields"]', function(e) {
  var $parent  = $(this).prev(['[data-behavior="dynamic-fields-parent"]']),
      fields   = setDynamicFieldIDs($(this).data('fields'));

  $parent.append(fields);

  if($(this).is('#add-event-button')) {
    var index = $("#event-list-parent").children("li").length - 1;
    $('#event-list-parent').trigger('afterAppendScheduledItem', index);
  }

  $(document).trigger('dynamic_fields_added', [$(fields)]);
});
/*
 * This javascript is used when you have a has_many resource and you want
 * to add or remove those nested resources from the parent.  This, along
 * with some rails helpers lets you do just that.
 */

$(document).on('click', '[data-behavior="remove-dynamic-fields"]', function(e) {
 e.preventDefault();
 $(this).prev("input[type=hidden]").val("1");
 $(this).parents('[data-behavior="dynamic-fields"]').hide();
});

$(document).on('click', '[data-behavior="add-dynamic-fields"]', function(e) {
 var new_id  = new Date().getTime();
 var regexp  = new RegExp("new_dynamic_fields", "g")
 var parent  = $(this).prev(['[data-behavior="dynamic-fields-parent"]'])
 var $fields = $($(this).data('fields').replace(regexp, new_id));
 parent.append($fields);
 $(document).trigger('dynamic_fields_added', [$fields]);
});
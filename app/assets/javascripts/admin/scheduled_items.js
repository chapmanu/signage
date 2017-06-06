Utils.fireWhenReady(['slides#edit'], function(e) {
  var $itemContainer = $("#event-list-parent"), $items;

  $itemContainer.sortable({
    items: 'li:not(.sortable-state-disabled)',
    update: refreshItemList
  });

  refreshItemList();

  $itemContainer.collapsible({
    accordion: false,
    onOpen: onCollapsibleOpen,
    onClose: onCollapsibleClose
  });

  $(document).on("click", ".add-scheduled-item", onInsertItemClick);
  $(document).on("click", ".remove-scheduled-item, .remove-scheduled-item-btn", onRemoveItemClick);
  $(document).on("click", ".move-up-scheduled-item", onMoveItemUp);
  $(document).on("click", ".move-down-scheduled-item", onMoveItemDown);
  $(document).on("focusout", ".event-item-name", onItemNameUpdate);
  $(document).on("afterAppendScheduledItem", $itemContainer, onAfterAppendScheduledItem);

  function onCollapsibleOpen(el) {

    $(el).removeClass('sortable-state-disabled').addClass('sortable-state-disabled');
    $itemContainer.sortable({ cancel: '.sortable-state-disabled' });
  }

  function onCollapsibleClose(el) {
    $(el).removeClass('sortable-state-disabled');
  }

  //Inserts a new event item after currently selected item
  function onInsertItemClick(event){
    var $el = $(this).closest('.scheduled-item-fields'),
        fields  = setDynamicFieldIDs($("#add-event-button").data('fields')),
        insertIndex   = $items.index($el) + 1;

    $el.after(fields);
    $itemContainer.trigger('afterAppendScheduledItem', insertIndex);
    $(document).trigger('dynamic_fields_added', [$(fields)]);
  }

  function onAfterAppendScheduledItem(event, addedIndex){
    refreshItemList();
    var $addedItem = $items.eq(addedIndex);

    //Need to reinitialize materialize selects on dynamically created elements to display correctly
    $addedItem.find('select').not('.disabled').material_select();

    $itemContainer.collapsible('open', addedIndex);
    $itemContainer.removeClass('empty');
    onCollapsibleOpen($addedItem);
    $('html, body').animate({ scrollTop: $addedItem.offset().top });
  }

  function onRemoveItemClick(){
    var $el = $(this).closest('.scheduled-item-fields');
    $el.addClass('removed');
    $el.find('.remove-scheduled-item-btn input[type=hidden]').val(1);
    $el.hide();
    refreshItemList();
    if(!$items.length){ $itemContainer.addClass('empty'); }
  }

  function onMoveItemUp() {
    var item = $(this).closest('.scheduled-item-fields'),
        index = $items.index(item),
        prevItem = $items.eq(index - 1);

    item.insertBefore(prevItem);
    refreshItemList();
  }

  function onMoveItemDown() {
    var item = $(this).closest('.scheduled-item-fields'),
        index = $items.index(item),
        nextItem = $items.eq(index + 1);

    item.insertAfter(nextItem);
    refreshItemList();
  }

  function onItemNameUpdate() {
    var itemHeader = $(this).closest('.scheduled-item-fields')
        .children(".collapsible-header").find(".event-name");
    itemHeader.html($(this).val());
  }

  function refreshItemList() {
    $items = $itemContainer.children('li').not(".removed");

    $items.each(function(index){
      $(this).removeClass('first last');
      $(this).children(".scheduled-item-order").val(index);
    });

    $items.first().addClass('first');
    $items.last().addClass('last');
  }
});
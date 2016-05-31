Utils.fireWhenReady(['home#index', 'notifications#index'], function(e) {
  $('.approve-sign-slide, .reject-sign-slide').on('click', function(event) {
    var message = $(this).parent().siblings('.input-field').children('input').val();
    $(this).attr('data-message', message);
    $.post($(this).attr('href') + "?message=" + encodeURIComponent(message) );
    return false;
  });
});
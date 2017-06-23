/**
 *  Ugly Temporary Add Owner Callback
 *  This is a temporary fix to allow users to add owners to slides. The issue is connected to the jQuery autocomplete not working.
 *  See GitHub issue: https://github.com/chapmanu/signage/issues/183
 *  There is believed to be a naming conflict with jQuery autocomplete and the Materialize autocomplete function that was added in version 0.98.0
 *  This fix may be able to be removed when Materialize fixes the naming issue on their end.
 */

var AddOwnerMonkeyPatch = (function() {

  var url;

  var setURL = function(newURL){
    url = newURL;
  }

  var onClick = function(e){
    
    // stop all
    e.preventDefault();

    var user = $('#search_users').val();

    $.ajax({
      url: url + user,
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
  }

  return {
    onClick: onClick,
    setURL: setURL
  }

})();
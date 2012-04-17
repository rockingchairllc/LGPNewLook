// generic error display.  errors is an array, element is the ul to add errors
function handle_errors(errors, element){
  if (!element) { element='errors';};
  var _li=[];
  for (var i in errors){ _li.push('<li>' + errors[i] + '</li>'); };
  $('#' + element).html('');
  $('#' + element).append(_li.join(''));
  $('#' + element).css('display', 'block');
};

// handles json responses from standard fields
 // redirects if needed
 // displays errors
 // call back function
function generic_form_handler(data, callback_function){
  if(data.success == true) {
    if (data.redirect) { window.location.href = data.redirect; return; };
    if (callback_function){ callback_function() };
  } else {
    handle_errors(data.errors);
  };
};
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
function generic_form_handler(data, callback_function, error_element){
  if(data.success == true) {
    if (data.redirect) { window.location.href = data.redirect; return; };
    if (callback_function){ callback_function() };
  } else {
      handle_errors(data.errors, error_element);
  };
};

// gets all url params into a hash
function getUrlVars(){
  var vars = [], hash;
  var hashes = window.location.href.replace('#_=_','').slice(window.location.href.indexOf('?') + 1).split('&');
  for(var i = 0; i < hashes.length; i++){
    hash = hashes[i].split('=');
    vars.push(hash[0]);
    vars[hash[0]] = hash[1];
  }
  return vars;
};

// returns a specific url param
function getUrlParam(param){
  var url_params=getUrlVars();
  return url_params[param];
};
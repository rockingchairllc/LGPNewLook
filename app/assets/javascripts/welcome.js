$(document).ready(function(){
  $('#form_invite_code').bind('ajax:success', function(evt, data, status, xhr) { generic_form_handler(data, invite_success, request_invite_success ); });

  $('#form_invite_request').bind('ajax:success', function(evt, data, status, xhr) { generic_form_handler(data, request_invite_success, 'form_invite_request_errors' ); });

  $('#form_sign_in').bind('ajax:success', function(evt, data, status, xhr) { generic_form_handler(data, null, null ); });
  $('#form_sign_in').bind('ajax:error', function(e, jqxhr, settings, exception) { sign_in_error_handler(e,jqxhr, settings, exception )});

});

function show_modal(id){
  $('#' + id).modal({
     show : true,
     keyboard : true,
     backdrop : true
  });
};
function hide_modal(id){
  $('#'+id).modal('hide');
};

function invite_success(){
  show_modal('modal_sign_up');
};

function request_invite_success(){
  hide_modal('modal_request_invite');
  show_modal('modal_request_invite_success');
}
function sign_in_error_handler(e,jqxhr, settings, exception){
  var error=JSON.parse(jqxhr["responseText"]);
  console.log(error["error"]);
  handle_errors([error["error"]], 'form_sign_in_errors' )
}
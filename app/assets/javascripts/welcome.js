$(document).ready(function(){
  $('#form_invite_code').bind('ajax:success', function(evt, data, status, xhr) { generic_form_handler(data, invite_success, request_invite_success ); });

  $('#form_invite_request').bind('ajax:success', function(evt, data, status, xhr) { generic_form_handler(data, request_invite_success, 'form_invite_request_errors' ); });

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
$(document).ready(function(){
  $('#form_invite_code').bind('ajax:success', function(evt, data, status, xhr) { generic_form_handler(data, invite_success ); });
});

function show_modal(id){
  $('#' + id).modal({
     show : true,
     keyboard : true,
     backdrop : true
  });
}

function invite_success(){
  show_modal('modal_sign_up');
};
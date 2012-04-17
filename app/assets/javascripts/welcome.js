$(document).ready(function(){
  $('#form_invite_code').bind('ajax:success', function(evt, data, status, xhr) { generic_form_handler(data, invite_success ); });
});

function invite_success(){
  alert('hi');
}
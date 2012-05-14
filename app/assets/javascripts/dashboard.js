
$(document).ready(function () {
  if ($('#modal_user_profile_exists').attr('exists') == "1"){
    show_modal('modal_user_profile');
    // no longer a remote form
    //$('#form_user_profile').bind('ajax:success', function(evt, data, status, xhr) { generic_form_handler(data, profile_update_success, 'form_user_profile_errors'); });
  }
});

function submit_profile_form(){
  console.log('submitting form');
  $('#form_user_profile').submit();
};
function profile_update_success(){
  hide_modal('modal_user_profile');
};


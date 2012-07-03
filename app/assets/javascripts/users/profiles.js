//= require users/movie_summary_modal

$(document).ready(function () {
  if ($('#form_user_profile_errors').length > 0){
    show_modal('modal_user_profile');
  }
});

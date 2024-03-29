//= require users/movie_summary_modal

function submit_search(){
  var movie = $('#select_movie').val();
  var miles = $('#select_miles').val();
  var zip   = $('#field_zip').val();
  window.location='/users/profiles?movie=' + movie + '&zip=' + zip + '&miles=' + miles;
}



$(document).ready(function () {

  $('[rel=tooltip]').tooltip({ delay: { show: 0, hide: 0 } } );

  $('.search_filter').click(function(){
    submit_search();
  });
  $('#field_zip').keypress(function(e) { if(e.which == 13) { submit_search(); } });


  if ($('#form_user_profile_errors').length > 0){
    show_modal('modal_user_profile');
  }

  $('.questions-and-answer-portion .edit_link a').each(function(){
    $(this).on('click', function(){
      var question_id  = $(this).attr('data');
      $('.questions-and-answer-portion  #edit-' + question_id).show();
      $('.questions-and-answer-portion  #read-only-' + question_id).hide();
    })
  });

  $('.questions-and-answer-portion .edit_answer').each(function(){
    $(this).bind("ajax:success", function(xhr, data, status) {
      answer_handle_callback(data, status);
    });
  });
  $('.questions-and-answer-portion .new_answer').each(function(){
    $(this).bind("ajax:success", function(xhr, data, status) {
      answer_handle_callback(data, status);
    });
  });

});

function answer_handle_callback(data){
  console.log([data, status]);
  if (data.success){
    $('.questions-and-answer-portion  #edit-' + data.question_id).hide();
    $('.questions-and-answer-portion  #read-only-' + data.question_id).show();
    if (data.new_response=='')
      data.new_response='no answer';
    $('.questions-and-answer-portion  #read-only-' + data.question_id).html(data.new_response.replace(/\n/g, '<br />'));
  }
}


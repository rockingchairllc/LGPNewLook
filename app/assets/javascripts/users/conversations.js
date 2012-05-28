$('#movie_id').change(function() {
    // get variable for movie id and user id
    var user_id = $("#recipient_id").val();
    var movie_id = $("#movie_id").val();
    // make call to the rails function
  $.ajax("update_preferred_theaters?user_id="+ user_id + "&movie_id=" + movie_id) //placeholder variables for testing
});
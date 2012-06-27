/*
 * require jq/jquery.autoellipsis-1.0.3
 */

(function($){

  function submit_search(){
    var miles = $('#select_miles').val();
    var zip   = $('#field_zip').val();
    var search   = $('#field_search').val();
    window.location='/users/movies?miles=' + miles + '&zip=' + zip + '&search=' + search;
  }

  $('.search_filter').click(function(){
    submit_search();
  });

  $('#field_search').keypress(function(e) { if(e.which == 13) { submit_search(); } });
  $('#field_zip').keypress(function(e) { if(e.which == 13) { submit_search(); } });
})(jQuery);

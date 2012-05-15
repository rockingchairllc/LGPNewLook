/*
 * require jq/jquery.autoellipsis-1.0.3
 */

(function($){
  
  $('#zip_code_filter').click(function(){
    var miles = $('#select_miles').val();
    var zip   = $('#field_zip').val();
    window.location='/movies?miles=' + miles + '&zip=' + zip;
  });

  $('.movie_synopsis_lists').each(function(){

    $(this).on('click', 'a.watch-lists-add', function(){
      var self      = $(this).parent('.watchlist-action');
      var user_id   = 1;
      var movie_id  = self.attr('data-movie-id');

      $.post('/users/watch_lists', {'user_id' : user_id, 'movie_id' : movie_id },
        function(data){
          console.log(data);
          if (data.success){
            // do something to show it was added.
            self.addClass('is_watched');
          } else{
            // handle the error however you want.... display error returned from app or generic message.
            self.addClass('is_watched');
          }
        },
      'json' );
      
    });

    $(this).on('click', 'a.watch-lists-rem', function(){
      var self      = $(this).parent('.watchlist-action');
      var user_id   = 1;
      var movie_id  = self.attr('data-movie-id');

      $.post('/users/watch_lists/0', {'_method' : 'delete', 'user_id' : user_id, 'movie_id' : movie_id },
        function(data){
          console.log(data);
          if (data.success){
            // do something to show it was added.
            self.removeClass('is_watched');
          } else{
            // handle the error however you want.... display error returned from app or generic message.
            self.removeClass('is_watched');
          }
        },
      'json' );
    });

  });

})(jQuery);

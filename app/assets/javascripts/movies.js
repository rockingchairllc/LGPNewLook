(function($){
  
  $('#zip_code_filter').click(function(){
    var miles = $('#select_miles').val();
    var zip   = $('#field_zip').val();
    window.location='/movies?miles=' + miles + '&zip=' + zip;
  });

  $('.watchlist-action').each(function(){
    var self = $(this);
    var user_id = 1;
    var movie_id = self.attr('data-movie-id');

    self.find('a.remove').click(function(){
      console.log('remove here');
      
      $.post('/watch_lists/0', {'_method' : 'delete', 'user_id' : user_id, 'movie_id' : movie_id },
      function(data){
        console.log(data);
        if (data.success){
          // do something to show it was added.
          self.removeClass('is_watched');
        } else{
          // handle the error however you want.... display error returned from app or generic message.
        }
      }, 'json' );

    });
    
    self.find('a.add').click(function(){

      $.post('/watch_lists', {'user_id' : user_id, 'movie_id' : movie_id },
        function(data){
          console.log(data);
          if (data.success){
            // do something to show it was added.
            self.addClass('is_watched');
          } else{
            // handle the error however you want.... display error returned from app or generic message.
          }
      }, 'json' );
      
    });
  })

})(jQuery);

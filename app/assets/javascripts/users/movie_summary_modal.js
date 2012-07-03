(function($){

  $('a.refresh_preferred_theaters').each(function(){
    $(this).on('click', function(){
      var movie_id = $(this).attr('movie_id');
      var preferred_theaters = $(this).parents('.preferred_theaters');
      var zip_code = preferred_theaters.children('input')[0].value;
      var theater_list=preferred_theaters.find('ul');
      var error_div=preferred_theaters.find('.search_error');

      theater_list.children('li').remove();

      if (zip_code==''){
        error_div.show();
        return;
      }

      $.get('/users/movies/' + movie_id + '.json', { 'miles': 100, 'zip': zip_code },
        function(data){
          console.log(data);
          if (data && data.theaters){
            var number_loaded=0;
            for (var i = 0; i < data.theaters.length; i++) {
              // break after 4 have been loaded
              if (number_loaded==4) break;
              // if item is already on page -- ( existing subscription ) -- don't show it.
              var current=$('#watch_list_theater_' + data.theaters[i].id);
              if (current.length > 0) continue;
              error_div.hide();
              theater_list.append('<li><input id="watch_list_theater_' + data.theaters[i].id + '" type="checkbox" value="' + data.theaters[i].id + '" name="watch_list_theaters">' + data.theaters[i].name + '</li>');
              number_loaded++;
            }
          } else {
            // handle failure -- bad zip code?
            error_div.show();
          } ;
        },
        'json'
      );
    });
  });

  $('a.watch-lists-rem').each(function(){
    $(this).on('click', function(){

      var self      = $(this).parents('.watchlist-action');
      var movie_id  = $(this).attr('data_movie_id');
      var user_id   = $(this).attr('data_user_id');

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

  $('a.watch-lists-add-summary').each(function(){
    $(this).on('click', function(){
      var movie_id=$(this).attr('data_movie_id');
      hide_modal('summary_' + movie_id);
      show_modal('watchlist_' + movie_id);
    });
  });

  $('a.watch-lists-add').each(function(){
    $(this).on('click', function(){
      var self      = $(this).parents('.watchlist-action');
      var movie_id  = $(this).attr('data_movie_id');
      var user_id   = $(this).attr('data_user_id');
      var optional_note=$('#watchlist_' + movie_id + ' #optional_note').val();
      var watch_list_theaters = [];

      $('#watchlist_' + movie_id + ' input[name="watch_list_theaters"]').each(function(index, element){
        if (element.checked){
          watch_list_theaters.push(element.value)
        }
      });

      $.post('/users/watch_lists', {'user_id' : user_id, 'movie_id' : movie_id,
          'optional_note' : optional_note, 'watch_list_theaters' : watch_list_theaters },
        function(data){
          console.log(data);
          if (data.success){
            // do something to show it was added.
            if (window.location.pathname.substring(0,15) == '/users/profiles'){
              console.log('refreshing page');
              window.location.reload();
            }
            hide_modal('watchlist_' + movie_id);
            self.addClass('is_watched');
          } else{
            // handle the error however you want.... display error returned from app or generic message.
            self.addClass('is_watched');
          }
        }, 'json' );
    });
  });
})(jQuery);

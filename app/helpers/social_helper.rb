module SocialHelper


  def facebook_common_fbxml()
    raw('
      <div id="fb-root"></div>
      <script>(function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=' + Configuration.facebook_app_id + '";
        fjs.parentNode.insertBefore(js, fjs);
      }(document, \'script\', \'facebook-jssdk\'));</script>
      ')
  end

  def facebook_common(callback)
    raw('
      <div id="fb-root"></div>
      <script>
        window.fbAsyncInit = function() {
          FB.init({
            appId      : \'' + LGPConfiguration.facebook_app_id + '\', // App ID
            status     : true, // check login status
            cookie     : true, // enable cookies to allow the server to access the session
            oauth      : true, // enable OAuth 2.0
            xfbml      : true  // parse XFBML
          });

          ' + callback + '
        };

        // Load the SDK Asynchronously
        (function(d){
           var js, id = \'facebook-jssdk\'; if (d.getElementById(id)) {return;}
           js = d.createElement(\'script\'); js.id = id; js.async = true;
           js.src = "//connect.facebook.net/en_US/all.js";
           d.getElementsByTagName(\'head\')[0].appendChild(js);
         }(document));

      </script>
      ')
  end

end
Lgp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # mailer options for dev ---  perform actual mail deliveries
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"

  # these options are only needed if you choose smtp delivery
  config.action_mailer.smtp_settings = {
      :address              => 'smtp.gmail.com',
      :port                 => 587,
      :domain               => 'imap.gmail.com',
      :user_name            => 'kiplmailtest@gmail.com',
      :password             => 'kipltest',
      :authentication       => 'login',
      :enable_starttls_auto => true
    }

#  #----- qen: for my local run
#  # action mailer config
#  config.action_mailer.default_url_options    = { :host => 'ror.vmcentos.net' }
#  config.action_mailer.delivery_method        = :sendmail
#  config.action_mailer.perform_deliveries     = true
#  config.action_mailer.raise_delivery_errors  = true
#
#  ActionMailer::Base.default :from => 'root@vmcentos.net',
#    :mime_version => "1.0",
#    :charset      => "UTF-8",
#    :content_type => "multipart/alternative",
#    :parts_order  => [ "text/html", "text/plain", "text/enriched" ]
#
#  # default routes host
#  # http://stackoverflow.com/questions/341143/can-rails-routing-helpers-i-e-mymodel-pathmodel-be-used-in-models
#  routes.default_url_options[:host]           = 'ror.vmcentos.net'
#  #---- qen: end here
  
    
  # Do not compress assets
  config.assets.compress=false

  # Expands the lines which load the assets
  config.assets.debug=true
  config.assets.compile=true


  # FB config for DEVELOPMENT APP.
  config.after_initialize do
    LGPConfiguration.facebook_app_id = '374526839255198'
    LGPConfiguration.facebook_secret = '7449426519ece5238bd4730bc7ff2a36'
  end

end

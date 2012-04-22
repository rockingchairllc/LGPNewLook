# any custom config you want to have across all environments
class LGPConfiguration
  class << self
    attr_accessor :facebook_app_id
    attr_accessor :facebook_secret
  end
end
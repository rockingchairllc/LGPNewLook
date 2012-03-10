class MessageController < ApplicationController
  before_filter :authenticate_user!
  def message
  end
end
module ConversationsHelper
  
  def get_message_sender(user_id)
    User.find_by_id(user_id)
  end
end

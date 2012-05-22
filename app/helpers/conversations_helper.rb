module ConversationsHelper
  
  def get_message_sender(user_id)
    User.find_by_id(user_id)
  end

  def get_other_conversation_participant(conversation, current_user)
    receipt = conversation.receipts.where("receiver_id <> ?", current_user.id ).last
    # if there is no other user, the user might be messaging themselves
    receipt.nil? ? user_id = current_user.id : user_id = receipt.receiver_id
    User.find_by_id(user_id)
  end


end


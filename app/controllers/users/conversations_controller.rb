class Users::ConversationsController < UsersController

  before_filter :get_mailbox
  #before_filter :check_current_subject_in_conversation, :only => [:show, :update, :destroy]
  def index
    @conversations = @mailbox.inbox
    @mailbox_type = "inbox"
  end

  def show
    @message = Message.new
    @conversation = Conversation.where("id = ?", params[:id]).first
    @receipts = @conversation.receipts_for(current_user).order("created_at DESC")
    @receipts = remove_duplicate_receipts @receipts
    @recipient =  get_initial_recipient(@conversation)
    # check if there is a subject and therefore a movie title
    if @conversation.subject != "N/A"   #@TODO might want to change this later
      # get the movie object
      movie = Movie.find_by_title(@conversation.subject)
      # get the watchlist
      watch_list = WatchList.where("user_id = ? AND movie_id = ?", @recipient.id, movie.id).first
      #check for preferred theaters
      @preferred_theaters =  @recipient.watch_list_preferred_theaters(watch_list.id)
    end
  end

  def new
    if params[:recipient_id]
      @recipient = User.find_by_id(params[:recipient_id])
      @movies = @recipient.watchlist_movies
      if params[:watch_list_id]
        watch_list_item = WatchList.find(params[:watch_list_id])
        @default_movie = Movie.find(watch_list_item.movie_id)
        @preferred_theaters = @recipient.watch_list_preferred_theaters(watch_list_item.id)
      end
    end
  end

  def edit
    #@TODO if required
  end

  def create
    # verify everything
    recipient = User.find_by_id params[:recipient][:id]
    movie = Movie.find_by_id(params[:movie_id])
    body = params[:body][0]
    #@TODO add check here to make sure everything above is valid before sending message
    # create conversations e.g. send first message
    conversation = @current_user.send_message(recipient, body, movie.nil? ? "N/A" : movie.title )
    # return user to conversations page
    if conversation
      redirect_to users_conversations_path
    end
  end

  def sent
    @conversations = @mailbox.sentbox
    @mailbox_type = "sentbox"
  end

  def destroy
    @user = User.find_by_id(params[:id])
    @conversation = @user.mailbox.conversations.where("conversation_id = ?", params[:format]).first
    @conversation.move_to_trash(@user)
    redirect_to users_inbox_path(@user)
  end

  def reply_to_conversation
    conversation = Conversation.find_by_id(params[:conversation][:id])
    message_sent = current_user.reply_to_conversation(conversation, params[:body][:body])
    if message_sent
      redirect_to users_conversation_path(conversation)
    end
  end

  def update_preferred_theaters
    @recipient = User.find_by_id(params[:user_id])
    watch_list = WatchList.where("user_id = ? AND movie_id = ?", @recipient.id, params[:movie_id]).first
    @preferred_theaters = @recipient.watch_list_preferred_theaters(watch_list.id)
    if @preferred_theaters
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def get_mailbox
    @mailbox = current_user.mailbox
  end

  def get_actor
    @actor = Actor.normalize(current_user)
  end

  def get_box
    if params[:box].blank? or !["inbox","sentbox","trash"].include?params[:box]
      @box = "inbox"
    return
    end
    @box = params[:box]
  end

  def check_current_subject_in_conversation
    @conversation = Conversation.find_by_id(params[:id])

    if @conversation.nil? or !@conversation.is_participant?(@actor)
      redirect_to conversations_path(:box => @box)
    return
    end
  end

  def get_initial_recipient(conversation)
    # get last message receipt
    receipt = conversation.receipts.where("mailbox_type = ?", "inbox").order("created_at DESC").last
    # get receiving user
    user = User.find_by_id(receipt.receiver_id)
  end

  # if the user sends a message to themselves the first message will be repeated in both their inbox and outbox.
  # This removes that duplication.
  def remove_duplicate_receipts receipts
    size = receipts.size
    last = receipts[size-1]
    second_last = receipts[size-2]
    # check if they are the same
    if last.message == second_last.message
      receipts.pop
    end
    receipts
  end
end

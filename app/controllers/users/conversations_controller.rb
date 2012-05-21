class Users::ConversationsController < UsersController

  before_filter :get_mailbox
  #before_filter :check_current_subject_in_conversation, :only => [:show, :update, :destroy]
  def index
    @conversations = @mailbox.inbox
  end

  def show
    @message = Message.new
    @conversation = Conversation.where("id = ?", params[:id]).first
    @receipts = @conversation.receipts
  end

  def new
    @recipient = User.find_by_id(params[:recipient_id])
    @movies = Movie.all #@TODO change this to a more specific movies list.
  end

  def edit
    #@TODO if required
  end

  def create
    # verify everything
    recipient = User.find_by_firstname params[:recipient]   #@TODO this will change to an id once set up
    movie = Movie.find_by_id params[:movie_id]
    body = params[:body][0]
    #@TODO add check here to make sure everything above is valid before sending message
    # create conversations e.g. send first message
    conversation = @current_user.send_message(recipient, body, movie.title )
    # return user to conversations page
    if conversation
      redirect_to conversations_path
    end
  end

  def sent
    @conversations = @mailbox.sentbox
  end

  def destroy

    @conversation.move_to_trash(@actor)

    respond_to do |format|
      format.html {
        if params[:location].present? and params[:location] == 'conversation'
          redirect_to conversations_path(:box => :trash)
        else
          redirect_to conversations_path(:box => @box,:page => params[:page])
        end
      }
      format.js {
        if params[:location].present? and params[:location] == 'conversation'
          render :js => "window.location = '#{conversations_path(:box => @box,:page => params[:page])}';"
        else
          render 'conversations/destroy'
        end
      }
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

end

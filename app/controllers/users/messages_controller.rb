class Users::MessagesController < UsersController

  before_filter :get_mailbox, :get_box
  
  def index
    redirect_to conversations_path(:box => @box)
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    if @message = Message.find_by_id(params[:id]) and @conversation = @message.conversation
      if @conversation.is_participant?(@actor)
        redirect_to conversation_path(@conversation, :box => @box, :anchor => "message_" + @message.id.to_s)
      return
      end
    end
    redirect_to conversations_path(:box => @box)
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit

  end

  # POST /messages
  # POST /messages.xml
  def create
    @recipients = Array.new
    if params[:_recipients].present?
      params[:_recipients].each do |recp_id|
        recp = Actor.find_by_id(recp_id)
        next if recp.nil?
        @recipients << recp
      end
    end
    @receipt = @actor.send_message(@recipients, params[:body], params[:subject])
    if (@receipt.errors.blank?)
      @conversation = @receipt.conversation
      flash[:success]= t('mailboxer.sent')
      redirect_to conversation_path(@conversation, :box => :sentbox)
    else
      render :action => :new
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update

  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy

  end
  
  def reply_to_conversation
    conversation = Conversation.find_by_id(params[:conversation_id])
    message_sent = current_user.reply_to_conversation(conversation, params[:message][:body])
    if message_sent
      redirect_to conversation_path(conversation)
    end
  end

  private

  def get_mailbox
    @mailbox = current_user.mailbox
  end

  # remove this
  def get_actor
    @actor = Actor.normalize(current_subject)
  end

  def get_box
    if params[:box].blank? or !["inbox","sentbox","trash"].include?params[:box]
      @box = "inbox"
    return
    end
    @box = params[:box]
  end

end


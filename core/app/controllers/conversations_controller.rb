class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  def pavlov_options
    {current_user: current_user}
  end

  def index
    respond_to do |format|
      format.html { render_backbone_page }
      format.json do
        @conversations = query :conversations_with_users_message
        if @conversations
          render 'conversations/index'
        else
          render json: [], status: :not_found
        end
      end
    end
  end

  def show
    respond_to do |format|
      format.html { render_backbone_page }
      format.json do
        @conversation = query :conversation_get, params[:id]
        if @conversation
          @conversation.messages = query :messages_for_conversation, @conversation
          @conversation.recipients = (query :users_by_ids, @conversation.recipient_ids).values
        end
        if @conversation and @conversation.messages.length > 0
          render 'conversations/show'
        else
          render json: [], status: :not_found
        end
      end
    end
  end

  def create
    interactor :create_conversation_with_message, params[:fact_id], params[:recipients], params[:sender], params[:content]
    render json: {}
  end
end

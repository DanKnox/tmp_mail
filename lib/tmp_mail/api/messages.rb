module TmpMail
  class Api < Sinatra::Base

    before '/messages*' do
      authenticate_user!
    end

    get '/messages' do
      domain = Domain.find_by(name: params[:domain])
      inbox = current_user.inboxes.find_by(name: params[:inbox], domain_id: domain.id)
      messages = inbox.messages.order_by(:date.asc)

      serializer = array_serializer(messages, each_serializer: MessageSerializer)
      body serializer.to_json
    end

    get '/messages/:id' do
      message = Message.find(params[:id])
      serializer = MessageSerializer.new(message)
      body serializer.to_json
    end

  end
end

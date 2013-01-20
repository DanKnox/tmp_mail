module TmpMail
  class Api < Sinatra::Base

    before '/messages*' do
      authenticate_user!
    end

    get '/messages' do
      address = "#{params[:inbox]}@#{params[:domain]}"
      inbox = current_user.inboxes.find_by(address: address)

      serializer = array_serializer(inbox.messages, each_serializer: MessageSerializer)
      body serializer.to_json
    end

    get '/messages/:id' do
      message = Message.find(params[:id])
      serializer = MessageSerializer.new(message, current_user)
      body serializer.to_json
    end

  end
end

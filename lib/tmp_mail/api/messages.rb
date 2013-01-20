module TmpMail
  class Api < Sinatra::Base

    before '/messages*' do
      authenticate_user!
    end

    get '/messages' do
      address = "#{params[:inbox]}@#{params[:domain]}"
      inbox = current_user.inboxes.find_by(address: address)
      body(inbox.messages.to_json)
    end

    get '/messages/:id' do
      message = Message.find(params[:id])
      body(message.to_json)
    end

  end
end

module TmpMail
  class Api < Sinatra::Base

    helpers do
      def serialize_inboxes(inboxes)
        array_serializer(inboxes, each_serializer: InboxSerializer)
      end
    end

    before '/inboxes/*' do
      authenticate_user!
    end

    get '/inboxes' do
      inboxes = current_user.inboxes
      serializer = serialize_inboxes(inboxes)
      body serializer.to_json
    end

    post '/inboxes/claim' do
      if current_user.claim_inbox(params[:name], params[:domain])
        status 200
        serializer = serialize_inboxes(current_user.inboxes)
        body serializer.to_json
      else
        status 422
        body current_user.errors.to_json
      end
    end

  end
end

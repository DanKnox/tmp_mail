module TmpMail
  class Api < Sinatra::Base

    helpers do
      def serialize_inboxes(inboxes)
        ActiveModel::ArraySerializer.new(inboxes, each_serializer: InboxSerializer)
      end
    end

    before '/inboxes/*' do
      authenticate_user!
    end

    get '/inboxes' do
      inboxes = current_user.inboxes
      body inboxes.to_json
    end

    post '/inboxes/claim' do
      if current_user.claim_inbox(params[:name], params[:domain])
        status 200
        body current_user.inboxes.to_json
      else
        status 422
        body current_user.errors.to_json
      end
    end

  end
end

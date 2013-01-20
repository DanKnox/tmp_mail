module TmpMail
  class Api < Sinatra::Base

    helpers do
      def current_user
        @current_user ||= authenticate_user!
      end

      def authenticate_user!
        User.find_by(auth_token: params[:token])
      rescue Mongoid::Errors::DocumentNotFound
        raise InvalidAuthToken
      end
    end

    post '/account' do
      user = User.new(email: params[:email])
      user.password = params[:password]

      if user.save
        status 201
        serializer = UserSerializer.new(user, scope: nil)
        body serializer.to_json
      else
        status 422
        body user.errors.to_json
      end
    end

    put '/account' do
      current_user.email = params[:email]
      current_user.password = params[:password] if params[:password]

      if current_user.save
        status 201
        serializer = UserSerializer.new(user, scope: nil)
        body serializer.to_json
      else
        status 422
        body current_user.errors.to_json
      end
    end

    post '/authenticate' do
      begin
        user = User.find_by(email: params[:email])

        if user && (user.password == params[:password])
          status 201
          serializer = UserSerializer.new(user, scope: nil)
          body serializer.to_json
        else
          status 403
          body({error: "403: Forbidden"}.to_json)
        end
      rescue Mongoid::Errors::DocumentNotFound
        status 403
        body({error: "403: Forbidden"}.to_json)
      end
    end

    delete '/authenticate' do
      if current_user
        current_user.clear_auth_token!
        status 200
        body({message: "signed out"}.to_json)
      end
    end

  end
end

module TmpMail
  class Api < Sinatra::Base

    before '/domains*' do
      authenticate_user!
    end

    get '/domains' do
      domains = Domain.all
      body(domains.to_json)
    end

    post '/domains' do
      domain = Domain.create(name: params[:name])
      status 201
      body(domain.to_json)
    end

    post '/domains/join' do
      if current_user.join_domain(params[:name])
        status 200
        body current_user.domains.to_json
      else
        status 422
        body current_user.errors.to_json
      end
    end

  end
end

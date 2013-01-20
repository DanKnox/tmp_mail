module TmpMail
  class Api < Sinatra::Base

    before '/domains*' do
      authenticate_user!
    end

    helpers do
      def serialize_domains(domains)
        ActiveModel::ArraySerializer.new(domains, each_serializer: DomainSerializer)
      end
    end

    get '/domains' do
      domains = Domain.all
      serializer = serialize_domains(domains)
      body serializer.to_json
    end

    post '/domains' do
      domain = Domain.create(name: params[:name])
      status 201
      serializer = DomainSerializer.new(domain, current_user)
      body serializer.to_json
    end

    post '/domains/join' do
      if current_user.join_domain(params[:name])
        status 200
        serializer = serialize_domains(current_user.domains)
        body serializer.to_json
      else
        status 422
        body current_user.errors.to_json
      end
    end

  end
end

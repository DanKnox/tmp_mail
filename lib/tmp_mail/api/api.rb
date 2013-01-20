require "sinatra/base"
require "tmp_mail"
module TmpMail
  class Api < Sinatra::Base

    class InvalidAuthToken < StandardError
    end

    configure :development do
      use Rack::Reloader
    end

    helpers do
      def array_serializer(array, options)
        ActiveModel::ArraySerializer.new(array, options)
      end
    end

    before do
      content_type "application/json"
    end

    not_found do
      body({error: "404: Invalid URL"}.to_json)
    end

    error Mongoid::Errors::DocumentNotFound do
      status 404
      body({error: "404: Message Not Found"}.to_json)
    end

    error InvalidAuthToken do
      status 403
      body({error: "403: Forbidden"}.to_json)
    end

    error do
      body({error: "500: Whoa! Not good."}.to_json)
    end

  end
end

require_relative "users"
require_relative "inboxes"
require_relative "messages"
require_relative "domains"

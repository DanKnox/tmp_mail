$:.push File.dirname(__FILE__)

require "mail"
require "mongoid"
require "active_model_serializers"

ENV['MONGOID_ENV'] ||= 'development'

require "tmp_mail/config/configuration"

module TmpMail
  class << self
    def config
      @config ||= Configuration.new
    end
  end

  Mongoid.load!(config.mongoid_config)

  if ActiveModel::Serializer.respond_to?(:root=)
    ActiveModel::Serializer.root = config.include_root_in_json
  end

  if config.maildir_path
    Mailman.maildir = config.maildir_path
  end
end

require "tmp_mail/user"
require "tmp_mail/message"
require "tmp_mail/domain"
require "tmp_mail/address"
require "tmp_mail/inbox"
require "tmp_mail/processor"

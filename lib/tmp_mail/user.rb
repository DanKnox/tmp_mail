require "bcrypt"
require "tmp_mail/serializers/user"

module TmpMail
  class User

    include BCrypt
    include ActiveModel::SerializerSupport
    include Mongoid::Document

    field :email, type: String
    field :password_hash, type: String
    field :auth_token, type: String

    before_create :generate_auth_token

    validates_presence_of :email
    validates_uniqueness_of :email

    attr_accessible :email

    has_many :inboxes
    has_and_belongs_to_many :domains

    def active_model_serializer
      UserSerializer
    end

    def password
      @password ||= Password.new(password_hash)
    end

    def password=(new_password)
      @password = Password.create(new_password)
      self.password_hash = @password
    end

    def clear_auth_token!
      self.auth_token = nil
      save
    end

    def new_auth_token!
      generate_auth_token
      save
      auth_token
    end

    def claim_inbox(inbox_name, domain_name)
      domain = domains.find_by(name: domain_name)
      inbox = domain.inboxes.find_or_create_by(name: inbox_name)

      if inbox.user && inbox.user != self
        errors.add(:inbox, "has been claimed by another user")
        return nil
      else
        inboxes << inbox
        save
      end

      inbox
    rescue Mongoid::Errors::DocumentNotFound
      errors.add(:base, "You are not a member of this domain.")
      nil
    end

    def join_domain(domain_name)
      domains << Domain.find_by(name: domain_name)
      save
    rescue Mongoid::Errors::DocumentNotFound
      errors.add(:domain, "does not exist")
      nil
    end

    private

    def generate_auth_token
      self.auth_token = Base64.urlsafe_encode64(Array.new(25) { (65 + rand(58)).chr }.join)
    end

  end
end

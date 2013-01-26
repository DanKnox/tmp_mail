require "tmp_mail/serializers/inbox"

module TmpMail
  class Inbox

    include Mongoid::Document

    field :address, type: Address
    field :name, type: String

    has_many :messages
    belongs_to :domain
    belongs_to :user

    before_create :extract_name_or_address
    before_create :associate_domain

    validates_uniqueness_of :address

    def deliver(email)
      messages << Message.new(email)
      save
    end

    def message_count
      messages.count
    end

    def serializable_hash(*args)
      {
        name: name,
        message_count: messages.count,
        domain: domain.try(:name),
        full_address: address.to_s
      }
    end

    private

    def extract_name_or_address
      if name.nil?
        self.name = address.address.split("@").first
      elsif address.to_s.blank?
        self.address = Address.new("#{name}@#{domain.name}")
      end
    end

    def associate_domain
      return if domain.present?
      self.domain = Domain.find_or_create_by(name: address.domain)
    end

  end
end

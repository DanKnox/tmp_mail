require "tmp_mail/serializers/inbox"

module TmpMail
  class Inbox

    include Mongoid::Document

    field :address, type: Address
    field :name, type: String

    has_many :messages
    belongs_to :domain
    belongs_to :user

    before_create :associate_domain
    before_create :extract_name_or_address

    validates_uniqueness_of :address

    def deliver(email)
      messages << Message.new(email)
      save
    end

    def message_count
      messages.count
    end

    private

    def extract_name_or_address
      if name.nil?
        self.name = address.address.split("@").first
      elsif address.nil?
        self.address = "#{name}@#{domain.name}"
      end
    end

    def associate_domain
      self.domain = Domain.find_or_create_by(name: address.domain)
    end

  end
end

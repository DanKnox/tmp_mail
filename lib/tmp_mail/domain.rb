require "tmp_mail/serializers/domain"

module TmpMail
  class Domain

    include Mongoid::Document

    field :name, type: String

    has_many :inboxes
    has_and_belongs_to_many :users

  end
end

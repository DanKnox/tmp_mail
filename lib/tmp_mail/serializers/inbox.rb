module TmpMail
  class InboxSerializer < ActiveModel::Serializer

    attributes :name, :domain, :user, :message_count,
      :full_address

    def domain
      if object.domain
        domain.name
      end
    end

    def user
      if object.user
        { email: object.user.email }
      end
    end

    def full_address
      object.address.to_s
    end

  end
end

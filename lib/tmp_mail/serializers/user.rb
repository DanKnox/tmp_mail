module TmpMail
  class UserSerializer < ActiveModel::Serializer

    attributes :email, :auth_token

  end
end

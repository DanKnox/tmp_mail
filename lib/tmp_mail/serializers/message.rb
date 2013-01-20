module TmpMail
  class MessageSerializer < ActiveModel::Serializer

    attributes :id, :date, :subject, :to, :from, :reply_to,
      :cc_addrs, :bcc_addrs, :headers, :raw

    def date
      message.date
    end

    def subject
      message.subject
    end

    def to
      message.to
    end

    def from
      message.from
    end

    def reply_to
      message.reply_to
    end

    def cc_addrs
      message.cc_addrs
    end

    def bcc_addrs
      message.bcc_addrs
    end

    def headers
      message.headers
    end

    private

    def message
      object.message
    end

  end
end

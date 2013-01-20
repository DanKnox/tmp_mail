module TmpMail
  class Message

    include Mongoid::Document

    field :raw, type: String
    field :subject, type: String
    field :date, type: DateTime

    belongs_to :inbox

    def initialize(message)
      super() do |msg|
        msg.subject = message.subject
        msg.date = message.date
        msg.raw = message.to_s
      end
    end

    def message
      @message ||= ::Mail::Message.new(raw)
    end

  end
end

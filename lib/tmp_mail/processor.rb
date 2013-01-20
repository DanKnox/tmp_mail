module TmpMail
  class Processor

    def self.process(message)
      new(message).process
    end

    attr_reader :message

    def initialize(message)
      @message = message
    end

    def process
      inboxes = find_or_create_inboxes_for_recipients(message.to)
      deliver_message_to inboxes
    end

    private

    def find_or_create_inboxes_for_recipients(recipients)
      recipients.each_with_object([]) do |address, inboxes|
        inboxes << Inbox.find_or_create_by(address: address)
      end
    end

    def deliver_message_to(inboxes)
      inboxes.each { |inbox| inbox.deliver(message) }
    end

  end
end

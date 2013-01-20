require "spec_helper"

module TmpMail
  describe Processor do

    before do
      @email = Mail.read("#{FIXTURES}/email.eml")
      @processor = Processor.new(@email)
    end

    describe ".process" do
      it "creates a new Processor instance and calls #process" do
        Processor.any_instance.should_receive(:process)
        Processor.process(@email)
      end
    end

    describe "#process" do
      it "finds the inboxes of each message recipient" do
        @processor.stub(:deliver_message_to).as_null_object
        @processor.should_receive(:find_or_create_inboxes_for_recipients).with(@email.to)
        @processor.process
      end

      it "delivers the messages to the inboxes" do
        @processor.should_receive(:deliver_message_to)
        @processor.process
      end
    end

    describe "#find_or_create_inboxes_for_recipients" do
      it "returns an array of inboxes" do
        inboxes = @processor.send(:find_or_create_inboxes_for_recipients, @email.to)
        inboxes.count.should == 1
      end

      it "creates a new inbox if one does not exist" do
        Inbox.count.should == 0
        @processor.send(:find_or_create_inboxes_for_recipients, @email.to)
        Inbox.count.should == 1
      end
    end

    describe "#deliver_message_to" do
      it "delivers the message to each inbox" do
        inbox = stub('inbox')
        inbox.should_receive(:deliver).with(@email)
        @processor.send(:deliver_message_to, [inbox])
      end
    end

  end
end

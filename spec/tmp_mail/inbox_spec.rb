require "spec_helper"

module TmpMail
  describe Inbox do

    it "has an email address" do
      inbox = Inbox.new(address: "something@special.com")
      inbox.address.should be_a Address
    end

    it "has a domain" do
      inbox = Inbox.create(address: "something@notsospecial.com")
      inbox.domain.name.should == "notsospecial.com"
    end

    describe "#deliver" do
      before do
        @email = ::Mail.read("#{FIXTURES}/email.eml")
      end

      it "creates and stores a new Message" do
        inbox = Inbox.create(address: "dknox@threedotloft.com")
        inbox.deliver(@email)
        inbox.messages.count.should == 1
      end
    end

    describe "#message_count" do
      before do
        @inbox = Inbox.create(address: "dknox@threedotloft.com")
        @inbox.messages << Message.new(::Mail.read("#{FIXTURES}/email.eml"))
      end

      it "returns the message count" do
        @inbox.message_count.should == 1
      end
    end

  end
end

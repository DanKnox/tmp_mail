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

    describe "before_create hooks" do
      before do
        @domain = Domain.create(name: "super.com")
      end

      describe "#extract_name_or_address" do
        context "when creating an inbox by name" do
          it "creates a valid address" do
            inbox = @domain.inboxes.create(name: "testbox")
            inbox.address.to_s.should == "testbox@super.com"
          end
        end

        context "when creating an inbox by address" do
          it "extracts inbox name from the address" do
            inbox = Inbox.create(address: "testbox@super.com")
            inbox.name.should == "testbox"
          end
        end
      end

      describe "#associate_domain" do
        context "when creating an inbox through a domain" do
          it "associates the correct domain" do
            inbox = @domain.inboxes.create(name: "testbox")
            inbox.domain.should == @domain
          end
        end

        context "when creating an inbox by address" do
          it "associates the correct domain" do
            inbox = Inbox.create(address: "testbox@super.com")
            inbox.domain.should == @domain
          end
        end
      end
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

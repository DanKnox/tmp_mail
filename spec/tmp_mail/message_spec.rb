require "spec_helper"

module TmpMail
  describe Message do

    before do
      @email = ::Mail.read("#{FIXTURES}/email.eml")
      @message = Message.new(@email)
    end

    it "stores the raw message" do
      @message.raw.should == @email.to_s
    end

    it "has a subject" do
      @message.subject.should == "TmpMail Email"
    end

    it "has a sent_at date" do
      @message.date.should == @email.date
    end

    it "has a Mail::Message object" do
      @message.message.should == @email
    end

  end
end

require "spec_helper_api"

module TmpMail
  describe Api do

    before do
      @user = User.create(email: 'test@test.com')
      @domain = @user.domains.create(name: "threedotloft.com")
      @inbox = @user.claim_inbox("dknox", "threedotloft.com")
      @raw_email = Mail.read("#{FIXTURES}/email.eml")
      @inbox.deliver(@raw_email)
    end

    describe "GET /messages" do
      before do
        get '/messages', {token: @user.auth_token, domain: "threedotloft.com", inbox: "dknox"}
      end

      it "responds HTTP 200 ok" do
        response.status.should == 200
      end

      it "responds with a list of messages" do
        messages = JSON.parse(response.body)
        messages.count.should == 1
      end

      it "uses the message serializer" do
        messages = JSON.parse(response.body)
        messages.first['subject'].should == "TmpMail Email"
        messages.first['reply_to'].should == @raw_email.reply_to
        messages.first['date'].should == @raw_email.date.to_s
      end
    end

    describe "GET /messages/:id" do
      before do
        @message = @inbox.messages.last
        get "/messages/#{@message.id}", {token: @user.auth_token}
      end

      it "responds HTTP 200 OK" do
        response.status.should == 200
      end

      it "responds with the serialized email" do
        message = JSON.parse(response.body)
        message['subject'].should == "TmpMail Email"
        message['reply_to'].should == @raw_email.reply_to
        message['date'].should == @raw_email.date.to_s
      end
    end

  end
end

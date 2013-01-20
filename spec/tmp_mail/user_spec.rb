require "spec_helper"

module TmpMail
  describe User do

    it "has an email" do
      User.new(email: "frank.white@kingofnewyork.com").email.should == "frank.white@kingofnewyork.com"
    end

    it "has an encrypted password" do
      user = User.new
      user.password = "secret squirrel"
      user.password.should == "secret squirrel"
    end

    it "has an auth_token" do
      Base64.stub(:urlsafe_encode64).and_return("encrypted token")
      user = User.create(:email => 'test@test.com')
      user.auth_token.should == "encrypted token"
    end

    describe "#claim_inbox" do
      before do
        @user = User.create(email: 'test@test.com')
        @user.domains.create(name: "whatever.com")
      end

      context "when inbox does not exist" do
        it "creates a new inbox" do
          inbox = @user.claim_inbox("dknox", "whatever.com")
          inbox.is_a?(Inbox).should be_true
        end

        it "assigns the inbox to the user" do
          inbox = @user.claim_inbox("dknox", "whatever.com")
          @user.inboxes.count.should == 1
        end
      end

      context "when inbox exists" do
        context "and belongs to current_user" do
          it "returns the existing inbox" do
            existing = @user.inboxes.create(address: "test@whatever.com")
            inbox = @user.claim_inbox("test", "whatever.com")
            inbox.should == existing
          end
        end

        context "and hasn't been claimed yet" do
          it "assigns it to the current user" do
            existing = Inbox.create(address: "test@whatever.com")
            inbox = @user.claim_inbox("test", "whatever.com")
            inbox.should == existing
          end
        end

        context "and belongs to another user" do
          before do
            @other_user = User.new(email: 'other@user.org')
            @other_user.save
            @other_user.inboxes.create(address: "test@whatever.com")
          end

          it "returns nil" do
            @user.claim_inbox("test", "whatever.com").should == nil
          end

          it "adds an error to the user" do
            @user.claim_inbox("test", "whatever.com")
            @user.errors[:inbox].should == ["has been claimed by another user"]
          end
        end

        context "and belongs to a domain the user hasn't joined" do
          before do
            Inbox.create(address: "test@anotherdomain.com")
          end

          it "returns nil" do
            @user.claim_inbox("test", "anotherdomain.com").should == nil
          end

          it "adds an error to the user" do
            @user.claim_inbox("test", "anotherdomain.com")
            @user.errors[:base].should == ["You are not a member of this domain."]
          end
        end
      end
    end

    describe "#join_domain" do
      before do
        @user = User.create(email: 'test@test.com')
        Domain.create(name: "existing.com")
      end

      context "an existing domain" do
        it "adds the user to the domain" do
          @user.join_domain("existing.com").should == true
          @user.domains.count.should == 1
        end
      end

      context "a domain that doesn't exist" do
        it "adds an error to the user" do
          @user.join_domain("doesnotexist.com").should == nil
          @user.errors[:domain].should == ["does not exist"]
        end
      end
    end

  end
end

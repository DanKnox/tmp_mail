require "spec_helper_api"

module TmpMail
  describe Api do

    before do
      @user = User.create(email: 'test@test.com')
      @user.domains.create(name: 'awesome.com')
      @user.claim_inbox("user", "awesome.com")
    end

    describe "GET /inboxes" do
      it "returns a list of the user's inboxes" do
        get '/inboxes', token: @user.auth_token
        inboxes = JSON.parse(response.body)
        inboxes.count.should == 1
      end
    end

    describe "POST /inboxes/claim" do
      it "claims the inbox for the user" do
        params = {token: @user.auth_token, name: 'another', domain: 'awesome.com'}
        post '/inboxes/claim', params
        @user.inboxes.count.should == 2
      end
    end
  end
end

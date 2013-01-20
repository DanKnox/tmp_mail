require "spec_helper_api"

module TmpMail
  describe Api do

    describe "POST /account" do
      before do
        @params = {email: 'test@mail.com', password: 'secret'}
        User.any_instance.stub(:auth_token).and_return('token')
        post '/account', @params
      end

      it "returns 201 OK" do
        response.status.should == 201
      end

      it "creates a new user account" do
        User.last.email.should == @params[:email]
      end

      it "returns a json representation of the user" do
        user = JSON.parse(response.body)
        user['email'].should == @params[:email]
        user['auth_token'].should == 'token'
      end

      context "when email is already taken" do
        before do
          post '/account', @params
        end

        it "returns 422 invalid" do
          response.status.should == 422
        end

        it "returns an error message" do
          errors = JSON.parse(response.body)
          errors['email'].should == ["is already taken"]
        end
      end
    end

    describe "POST /authenticate" do
      before do
        @user = User.new(email: 'test@test.com')
        @user.password = 'secret'
        @user.save
      end

      context "with valid email and password" do
        it "returns an auth token" do
          User.any_instance.stub(:auth_token).and_return('token')
          post '/authenticate', email: 'test@test.com', password: 'secret'
          user = JSON.parse(response.body)
          user['auth_token'].should == 'token'
        end
      end

      context "with an invalid email" do
        it "returns 403 forbidden" do
          post '/authenticate', email: 'invalid@user.com', password: 'invalid'
          response.status.should == 403
        end
      end

      context "with an invalid password" do
        it "returns 403 forbidden" do
          post '/authenticate', email: 'test@test.com', password: 'invalid'
          response.status.should == 403
        end
      end
    end

  end
end

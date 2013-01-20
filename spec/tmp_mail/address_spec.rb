require "spec_helper"

module TmpMail
  describe Address do

    it "inherits from ::Mail::Address" do
      subject.should be_a ::Mail::Address
    end

    it "provides mongoDB serialization" do
      email = Address.new("Dan Knox <dknox@threedotloft.com>")
      email.mongoize.should == "Dan Knox <dknox@threedotloft.com>"
    end

    it "provides mongoDB deserialization" do
      email = Address.demongoize("Dan Knox <dknox@threedotloft.com>")
      email.address.should == "dknox@threedotloft.com"
    end

  end
end

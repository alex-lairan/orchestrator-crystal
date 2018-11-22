require "../spec_helper"

describe Orchestrator::Composer do
  describe "with correct data" do
    it "return success" do
      input = { name: "Alex", email: "example@email.co" }.to_h
      transaction = UserComposer.new
      result = transaction.call(input)

      result.success?.should eq(true)
    end

    it "should return a user" do
      input = { name: "Alex", email: "example@email.co" }.to_h
      transaction = UserComposer.new
      result = transaction.call(input)

      result.value![:user].should eq(User.new(input[:name], input[:email]))
    end
  end

  describe "with bad data" do
    it "return failure" do
      input = { email: "example@email.co" }.to_h
      transaction = UserComposer.new
      result = transaction.call(input)

      result.failure?.should be_truthy
    end

    it "should not return user" do
      input = { email: "example@email.co" }.to_h
      transaction = UserComposer.new
      result = transaction.call(input)

      result.failure.should eq(:validation_error)
    end
  end

  describe "for nested compose" do
    describe "with correct data" do
      it "return success" do
        input = { name: "Alex", email: "example@email.co" }.to_h
        transaction = RegistrationComposer.new
        result = transaction.call(input)

        result.success?.should eq(true)
      end

      it "should return a user" do
        input = { name: "Alex", email: "example@email.co" }.to_h
        transaction = RegistrationComposer.new
        result = transaction.call(input)

        result.value![:user].should eq(User.new(input[:name], input[:email]))
      end
    end

    describe "with bad data" do
      it "return failure" do
        input = { email: "example@email.co" }.to_h
        transaction = RegistrationComposer.new
        result = transaction.call(input)

        result.failure?.should be_truthy
      end

      it "should not return user" do
        input = { email: "example@email.co" }.to_h
        transaction = RegistrationComposer.new
        result = transaction.call(input)

        result.failure.should eq(:validation_error)
      end
    end
  end
end

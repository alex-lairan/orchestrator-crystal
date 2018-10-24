describe Orchestrator::Composer do
  describe "with correct data" do
    it "return success" do
      input = { name: "Alex", email: "example@email.co" }.to_h
      transaction = UserComposer.new
      result = transaction.call(input)

      result.value!.should eq(input)
    end

    it "should increment USERS" do
      count = USERS.size

      input = { name: "Alex", email: "example@email.co" }.to_h
      transaction = UserComposer.new
      result = transaction.call(input)

      USERS.size.should eq(count + 1)
    end
  end

  describe "with bad data" do
    it "return failure" do
      input = { email: "example@email.co" }.to_h
      transaction = UserComposer.new
      result = transaction.call(input)

      result.failure.should be_truthy
    end

    it "should not increment USERS" do
      count = USERS.size

      input = {email: "example@email.co"}.to_h
      transaction = UserComposer.new
      result = transaction.call(input)

      USERS.size.should eq(count)
    end
  end
end

require "../spec_helper"

describe Orchestrator::Layer do
  describe "with no required property provided" do
    it "return failure" do
      input = Hash(Symbol, String).new
      layer = PropertyLayer.new

      layer.perform(input).class.should eq(Monads::Failure(Array(String)))
    end

    it "return messages" do
      input = Hash(Symbol, String).new
      layer = PropertyLayer.new

      layer.perform(input).failure.should eq(["name is missing"])
    end
  end

  describe "with required value" do
    it "return success" do
      input = { :name => "Foo" }
      layer = PropertyLayer.new

      layer.perform(input).class.should eq(Monads::Success(Hash(Symbol, Bool | String)))
    end

    it "return no option" do
      input = { :name => "Foo" }
      layer = PropertyLayer.new

      layer.perform(input).value!.should eq({
        :name => "Foo",
        :option_in => false
      })
    end

    describe "with optional" do
      it "return success" do
        input = { :name => "Foo", :option => true }
        layer = PropertyLayer.new

        layer.perform(input).class.should eq(Monads::Success(Hash(Symbol, Bool | String)))
      end

      it "return option" do
        input = { :name => "Foo", :option => true }
        layer = PropertyLayer.new

        layer.perform(input).value!.should eq({
          :name => "Foo",
          :option => true,
          :option_in => true
        })
      end
    end
  end
end

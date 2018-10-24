require "../../spec_helper"

describe Orchestrator::Pipeline::Tee do
  data = {
    :foo => :bar,
    :tee => :pot
  }

  describe "with failure" do
    it "return a success" do
      tee = Orchestrator::Pipeline::Tee.new(:a_step, FailureLayer)
      tee.call(data).success?.should be_truthy
    end

    it "return the input" do
      tee = Orchestrator::Pipeline::Tee.new(:a_step, FailureLayer)
      tee.call(data).value!.should eq(data)
    end
  end

  describe "with success" do
    it "return a success" do
      tee = Orchestrator::Pipeline::Tee.new(:a_step, SuccessLayer)
      tee.call(data).success?.should be_truthy
    end

    it "return the input" do
      tee = Orchestrator::Pipeline::Tee.new(:a_step, SuccessLayer)
      tee.call(data).value!.should eq(data)
    end
  end
end

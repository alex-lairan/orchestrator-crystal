require "../../spec_helper"

describe Orchestrator::Pipeline::Composer do
  data = {
    :foo => :bar,
    :tee => :pot
  }

  describe "with failure" do
    it "return a failure" do
      composer = Orchestrator::Pipeline::Composer.new(:a_step, FailureLayer)
      composer.call(data).failure?.should be_truthy
    end

    it "return the input" do
      composer = Orchestrator::Pipeline::Composer.new(:a_step, FailureLayer)
      composer.call(data).failure.should eq(data)
    end
  end

  describe "with success" do
    it "return a success" do
      composer = Orchestrator::Pipeline::Composer.new(:a_step, SuccessLayer)
      composer.call(data).success?.should be_truthy
    end

    it "return the input" do
      composer = Orchestrator::Pipeline::Composer.new(:a_step, SuccessLayer)
      composer.call(data).value!.should eq(data)
    end
  end
end

class FailureLayer < Orchestrator::Layer
  def call(input)
    Monads::Failure.new(input)
  end
end

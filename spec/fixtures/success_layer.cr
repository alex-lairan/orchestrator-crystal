class SuccessLayer < Orchestrator::Layer
  def call(input)
    Monads::Success.new(input)
  end
end

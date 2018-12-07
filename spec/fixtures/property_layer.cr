class PropertyLayer < Orchestrator::Layer
  required name, String
  optional option, Bool

  def call(input : Hash)
    if option
      Monads::Success.new(input.merge({ :option_in => true }))
    else
      Monads::Success.new(input.merge({ :option_in => false }))
    end
  end
end

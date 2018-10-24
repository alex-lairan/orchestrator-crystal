module Orchestrator
  abstract class Layer
    abstract def call(input : Hash) : Monads::Result

    def rollback(fallback : Monads::Result) : Void
      # no-op
    end
  end
end

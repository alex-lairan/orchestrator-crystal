module Orchestrator
  module Pipeline
    abstract class Item
      abstract def call(input : Hash)

      def rollback(input : Monads::Result) : Void
      end
    end
  end
end

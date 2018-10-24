require "./item"

module Orchestrator
  module Pipeline
    class Composer < Item
      @layer : Orchestrator::Layer

      def initialize(@name : Symbol, klass)
        @layer = klass.new
      end

      def call(input : Hash) : Monads::Result
        result = @layer.call(input)

        @layer.rollback(result) if result.failure?

        result
      rescue error : Exception
        Monads::Failure.new(error)
      end
    end
  end
end

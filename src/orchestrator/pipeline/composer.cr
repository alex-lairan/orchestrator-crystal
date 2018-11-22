require "./item"

module Orchestrator
  module Pipeline
    class Composer < Item
      @layer : Orchestrator::Layer | Orchestrator::Composer

      def initialize(@name : Symbol, klass)
        @layer = klass.new
      end

      def initialize(@name : Symbol, @layer : Orchestrator::Composer)
      end

      def call(input : Hash) : Monads::Result
        result = @layer.call(input)

        rollback(result) if result.failure?

        result
      rescue error : Exception
        Monads::Failure.new(error)
      end

      def rollback(result)
        @layer.rollback(result)
      end
    end
  end
end

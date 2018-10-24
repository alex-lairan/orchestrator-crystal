require "./item"

module Orchestrator
  module Pipeline
    class Tee < Item
      @layer : Orchestrator::Layer

      def initialize(@name : Symbol, klass)
        @layer = klass.new
      end

      def call(input : Hash) : Monads::Result
        result = @layer.call(input)
        Monads::Success.new(input)
      end
    end
  end
end

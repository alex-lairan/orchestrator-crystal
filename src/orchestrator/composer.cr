require "./layer"
require "./pipeline/composer"
require "./pipeline/tee"

module Orchestrator
  class Composer
    @@steps = Array(Pipeline::Item).new

    def self.compose(name : Symbol, klass : Orchestrator::Layer.class)
      @@steps << Pipeline::Composer.new(name, klass)
    end

    def self.tee(name : Symbol, klass : Orchestrator::Layer.class)
      @@steps << Pipeline::Tee.new(name, klass)
    end

    def call(input : Hash) : Monads::Result
      monad = Monads::Success.new(input)
      previous = Monads::Success.new(input)

      @@steps.each_with_index do |step, i|
        data = monad.value!.merge(previous.value!)
        monad = Monads::Success.new(data)
        previous = step.call(data)

        return previous if previous.failure?
      end

      previous
    end
  end
end

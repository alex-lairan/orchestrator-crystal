require "./layer"
require "./pipeline/composer"
require "./pipeline/tee"

module Orchestrator
  class Composer
    @@steps = Array(Pipeline::Item).new

    def self.compose(name : Symbol, klass : Orchestrator::Layer.class)
      enqueue Pipeline::Composer.new(name, klass)
    end

    def self.tee(name : Symbol, klass : Orchestrator::Layer.class)
      enqueue Pipeline::Tee.new(name, klass)
    end

    def self.compose(name : Symbol, composer : Orchestrator::Composer)
      enqueue Pipeline::Composer.new(name, composer)
    end

    def self.enqueue(pipeline : Pipeline::Item)
      @@steps << pipeline
    end

    def perform(input : Hash) : Monads::Result
      call(input)
    end

    def call(input : Hash) : Monads::Result
      monad = Monads::Success.new(input)

      @@steps.each_with_index do |step, i|
        monad = step.call(monad.value!)

        return monad if monad.failure?
      end

      monad
    end

    def rollback(input : Monads::Result) : Void
      @@steps.reverse.each do |step|
        step.rollback(input)
      end
    end
  end
end

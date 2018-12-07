module Orchestrator
  abstract class Layer
    alias Key = Symbol | String
    alias Value = Pointer(Void)
    @@required = Array(Tuple(Key, Proc(Orchestrator::Layer, Value, Monads::Result(String)))).new
    @@optional = Array(Tuple(Key, Proc(Orchestrator::Layer, Value, Void))).new

    @@properties = Hash(Key, Value).new

    def [](key : Key?) : Value?
      @@properties[key]?
    end

    def []=(key : Key, value : Value)
      @@properties[key] = value
    end

    macro required(name, type)
      property {{name}} : {{type}}?
      @@required << {
        :{{name}},
        ->(layer : Orchestrator::Layer, input : Pointer(Void)) {
          layer[:{{name}}] = input

          if Box({{type}}?).unbox(input) == nil
            return Monads::Failure.new("{{name}} is missing")
          end

          if layer[:{{name}}]
            Monads::Success.new("{{name}} is present")
          else
            Monads::Failure.new("{{name}} is missing")
          end
        }
      }

      def {{name}} : {{type}}
        if value = self[:{{name}}]
          Box({{type}}?).unbox(value).not_nil!
        else
          raise "Nil value for {{name}} key"
        end
      end
    end

    macro optional(name, type)
      property {{name}} : {{type}}?
      @@optional << {
        :{{name}},
        ->(layer : Orchestrator::Layer, input : Pointer(Void)) {
          layer[:{{name}}] = input
        }
      }

      def {{name}} : {{type}}?
        if value = self[:{{name}}]
          Box({{type}}?).unbox(value)
        else
          nil
        end
      end
    end

    abstract def call(input : Hash) : Monads::Result

    def perform(input : Hash) : Monads::Result
      conditions = @@required.map do |value|
        pack = Box.box(input[value[0]]?)
        value[1].call(self, pack)
      end

      errors = conditions.select(&.failure?).map(&.failure)

      if errors.empty?
        @@optional.each do |value|
          pack = Box.box(input[value[0]]?)
          value[1].call(self, pack)
        end

        call(input).not_nil!
      else
        Monads::Failure.new(errors)
      end
    end

    def rollback(fallback : Monads::Result) : Void
      # no-op
    end
  end
end

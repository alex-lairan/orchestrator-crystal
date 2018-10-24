module Orchestrator
  module Pipeline
    abstract class Item
      abstract def call(input : Hash)
    end
  end
end

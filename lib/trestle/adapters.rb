module Trestle
  module Adapters
    extend ActiveSupport::Autoload

    require_relative "adapters/adapter"

    autoload :ActiveRecordAdapter
    autoload :DraperAdapter
    autoload :SequelAdapter

    # Creates a new Adapter class with the given modules mixed in
    # @param *modules [Array]
    # @return [Trestle::Adapters::Adapter]
    def self.compose(*modules)
      Class.new(Adapter) do
        modules.each { |mod| include(mod) }
      end
    end
  end
end

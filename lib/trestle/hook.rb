module Trestle
  class Hook
    require_relative "hook/helpers"
    require_relative "hook/set"

    # @return [Symbol]
    attr_reader :name

    # @return [Hash]
    attr_reader :options

    # @return [Proc]
    attr_reader :block

    # @param name [Symbol]
    # @param options [Hash]
    # @param &block [Proc]
    #
    # @return [void]
    def initialize(name, options={}, &block)
      @name    = name
      @options = options
      @block   = block
    end

    # @param other [#name, #options, #block]
    #
    # @return [Boolean]
    def ==(other)
      other.is_a?(self.class) &&
        name == other.name &&
        options == other.options &&
        block == other.block
    end

    # @param context [#instance_exec]
    #
    # @return [Boolean]
    def visible?(context)
      if options[:if]
        context.instance_exec(&options[:if])
      elsif options[:unless]
        !context.instance_exec(&options[:unless])
      else
        true
      end
    end

    # @param context [#instance_exec]
    #
    # @return [void]
    def evaluate(context, *args)
      context.instance_exec(*args, &block)
    end
  end
end

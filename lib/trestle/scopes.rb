module Trestle
  class Scopes
    require_relative "scopes/block"
    require_relative "scopes/scope"

    # @return [Array<Block>]
    attr_reader :blocks

    # @return [void]
    def initialize
      @blocks = []
    end

    # @param &block [Proc]
    #
    # @return [void]
    def append(&block)
      @blocks << Block.new(&block)
    end

    # Evaluates each of the scope blocks within the given admin context
    # and returns a hash of Scope objects keyed by the scope name.
    #
    # @param context [Doc::Unknown]
    #
    # @return [Doc::Unknown]
    def evaluate(context)
      @blocks.map { |block| block.scopes(context) }.flatten.index_by(&:name)
    end
  end
end

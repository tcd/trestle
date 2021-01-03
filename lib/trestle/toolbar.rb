module Trestle
  class Toolbar
    require_relative "toolbar/builder"
    require_relative "toolbar/context"
    require_relative "toolbar/item"
    require_relative "toolbar/menu"

    # @param builder [Trestle::Toolbar::Builder]
    # @return [void]
    def initialize(builder=Builder)
      @builder = builder
      clear!
    end

    # @return [void]
    def clear!
      @blocks = []
    end

    def groups(template, *args)
      Enumerator.new do |y|
        @blocks.each do |block|
          builder = @builder.new(template, *args)
          block.evaluate(builder, template, y, *args)
        end
      end
    end

    # @param &block [Proc]
    #
    # @return [void]
    def append(&block)
      @blocks.push(Block.new(&block))
    end

    # @param &block [Proc]
    #
    # @return [void]
    def prepend(&block)
      @blocks.unshift(Block.new(&block))
    end

    # Wraps a toolbar block to provide evaluation within the context of a template and enumerator
    class Block
      # @param &block [Proc]
      # @return [void]
      def initialize(&block)
        @block = block
      end

      def evaluate(builder, template, enumerator, *args)
        context = Context.new(builder, enumerator, *args)
        result = template.capture { template.instance_exec(context, *args, &@block) }
        enumerator << [result] if result.present?
      end
    end

  end
end

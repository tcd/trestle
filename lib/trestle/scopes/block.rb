module Trestle
  class Scopes
    # Wrapper around a Proc.
    class Block

      # @return [Proc]
      attr_reader :block

      # @param &block [Proc]
      # @return [void]
      def initialize(&block)
        @block = block
      end

      # Evaluates the scope block within the given admin context
      # and returns an array of the scopes that were defined.
      #
      # @return [Array<Unknown>]
      def scopes(context)
        context = Evaluator.new(context)
        context.instance_exec(context, &block)
        context.scopes
      end

      class Evaluator
        include EvaluationContext

        # @!attribute context [rw]
        #   @return [Doc::Unknown]

        # @return [Array<Trestle::Scopes::Scope>]
        attr_reader :scopes

        # @return [void]
        def initialize(context=nil)
          @context = context
          @scopes = []
        end

        # @param name [Symbol]
        # @param scope [Trestle::Scopes::Scope]
        # @param options [Hash]
        # @param &block [Proc]
        # @return [void]
        def scope(name, scope=nil, options={}, &block)
          if scope.is_a?(Hash)
            options = scope
            scope = nil
          end

          scopes << Scope.new(@context, name, options, &(scope || block))
        end

      end
    end
  end
end

module Trestle
  class Scopes
    class Evaluator

      include EvaluationContext

      # @!attribute context [rw]
      #   @return [Doc::Unknown]

      # @return [Array<Scope>]
      attr_reader :scopes

      # @param context [Doc::Unknown]
      # @return [void]
      def initialize(context=nil)
        @context = context
        @scopes = []
      end

      # @param name [Symbol]
      # @param scope [Scope]
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

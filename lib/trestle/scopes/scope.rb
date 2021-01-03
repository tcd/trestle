module Trestle
  class Scopes
    class Scope

      # @return [Symbol]
      attr_reader :name

      # @return [Options]
      attr_reader :options

      # @return [Proc]
      attr_reader :block

      # @param admin [Doc::Unknown]
      # @param name [Symbol]
      # @param options [Options]
      # @param &block [Proc]
      # @return [void]
      def initialize(admin, name, options={}, &block)
        @admin   = admin
        @name    = name
        @options = options
        @block   = block
      end

      # @return [Symbol]
      def to_param
        name
      end

      # @return [String]
      def label
        @options[:label] || @admin.t("scopes.#{name}", default: name.to_s.humanize.titleize)
      end

      # @return [Boolean]
      def default?
        @options[:default] == true
      end

      def apply(collection)
        if @block
          if @block.arity == 1
            @admin.instance_exec(collection, &@block)
          else
            @admin.instance_exec(&@block)
          end
        else
          collection.public_send(name)
        end
      end

      def count(collection)
        @admin.count(@admin.merge_scopes(collection, apply(collection)))
      end

      # @return [Boolean]
      def active?(params)
        active_scopes = Array(params[:scope])

        if active_scopes.any?
          active_scopes.include?(to_param.to_s)
        else
          default?
        end
      end

    end
  end
end

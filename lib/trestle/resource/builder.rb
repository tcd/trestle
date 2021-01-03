module Trestle
  class Resource
    class Builder < Admin::Builder

      self.admin_class = Resource
      self.controller = -> { ResourceController }

      def adapter(&block)
        klass = admin.adapter_class
        klass.class_eval(&block) if block_given?
        klass
      end

      def adapter=(adapter)
        admin.adapter_class = adapter
      end

      # @param actions [Array<Symbol>]
      #
      # @return [void]
      def remove_action(*actions)
        actions.each do |action|
          controller.remove_possible_method(action.to_sym)
          admin.actions.delete(action.to_sym)
        end
      end

      # @param &block [Proc]
      #
      # @return [void]
      def collection(&block)
        admin.define_adapter_method(:collection, &block)
      end

      # @param &block [Proc]
      #
      # @return [void]
      def find_instance(&block)
        admin.define_adapter_method(:find_instance, &block)
      end
      alias instance find_instance

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def build_instance(&block)
        admin.define_adapter_method(:build_instance, &block)
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def update_instance(&block)
        admin.define_adapter_method(:update_instance, &block)
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def save_instance(&block)
        admin.define_adapter_method(:save_instance, &block)
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def delete_instance(&block)
        admin.define_adapter_method(:delete_instance, &block)
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def to_param(&block)
        admin.define_adapter_method(:to_param, &block)
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def params(&block)
        admin.define_adapter_method(:permitted_params, &block)
      end

      # @param decorator [Doc::Unknown]
      #
      # @return [void]
      def decorator(decorator)
        admin.decorator = decorator
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def decorate_collection(&block)
        admin.define_adapter_method(:decorate_collection, &block)
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def merge_scopes(&block)
        admin.define_adapter_method(:merge_scopes, &block)
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def sort(&block)
        admin.define_adapter_method(:sort, &block)
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def sort_column(column, &block)
        admin.column_sorts[column.to_sym] = block
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def paginate(options={}, &block)
        admin.pagination_options = admin.pagination_options.merge(options)
        admin.define_adapter_method(:paginate, &block)
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def count(&block)
        admin.define_adapter_method(:count, &block)
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def scopes(&block)
        admin.scopes.append(&block)
      end

      # @param name [Symbol]
      # @param scope [Doc::Unknown]
      # @param options [Hash]
      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def scope(name, scope=nil, options={}, &block)
        scopes do
          scope(name, scope, options, &block)
        end
      end

      # @param options [Hash]
      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def return_to(options={}, &block)
        actions = options.key?(:on) ? Array(options[:on]) : [:create, :update, :destroy]

        actions.each do |action|
          admin.return_locations[action.to_sym] = block
        end
      end

      protected

      # @return [Array]
      def normalize_table_options(name, options)
        if name.is_a?(Hash)
          # Default index table
          name, options = :index, name.reverse_merge(sortable: true)
        end

        [name, options.reverse_merge(admin: admin)]
      end

    end
  end
end

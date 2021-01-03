module Trestle
  module Adapters
    module ActiveRecordAdapter

      # @param params [Hash]
      #
      # @return [Doc::Model]
      def collection(params={})
        model.all
      end

      # @param params [Doc::Unknown<ActionController::Parameters>]
      # @return [Doc::Model]
      def find_instance(params)
        model.find(params[:id])
      end

      # @param attrs [Hash]
      # @param params [Hash] Unused
      #
      # @return [Doc::Model]
      def build_instance(attrs={}, params={})
        model.new(attrs)
      end

      # @param instance [Doc::Model]
      # @param attrs [Hash]
      # @param params [Hash] Unused
      #
      # @return [Doc::Model]
      def update_instance(instance, attrs, params={})
        instance.assign_attributes(attrs)
      end

      # @param instance [Doc::Model]
      # @param params [Hash] Unused
      #
      # @return [Doc::Model]
      def save_instance(instance, params={})
        instance.save
      end

      # @param instance [Doc::Model]
      # @param params [Hash] Unused
      #
      # @return [void]
      def delete_instance(instance, params={})
        instance.destroy
      end

      def merge_scopes(scope, other)
        scope.merge(other)
      end

      def count(collection)
        collection.count(:all)
      end

      def sort(collection, field, order)
        collection.reorder(field => order)
      end

      # @param attribute [String,Symbol]
      # @param options [Hash] Unused
      #
      # @return [String]
      def human_attribute_name(attribute, options={})
        model.human_attribute_name(attribute, options)
      end

      def default_table_attributes
        default_attributes.reject do |attribute|
          inheritance_column?(attribute) || counter_cache_column?(attribute)
        end
      end

      def default_form_attributes
        default_attributes.reject do |attribute|
          primary_key?(attribute) || inheritance_column?(attribute) || counter_cache_column?(attribute)
        end
      end

      protected

      # @return [Array<Attribute, Attribute::Association>]
      def default_attributes
        model.columns.map do |column|
          if column.name.end_with?("_id") &&
             (name = column.name.sub(/_id$/, '')) &&
             (reflection = model.reflections[name])
            Attribute::Association.new(
              column.name,
              class: -> { reflection.klass },
              name: name,
              polymorphic: reflection.polymorphic?,
              type_column: reflection.foreign_type,
            )
          elsif column.name.end_with?("_type") &&
                (name = column.name.sub(/_type$/, '')) &&
                (reflection = model.reflections[name])
            # Ignore type columns for polymorphic associations
          else
            Attribute.new(column.name, column.type, array_column?(column) ? { array: true } : {})
          end
        end.compact
      end

      # @param attribute [Symbol]
      #
      # @return [Boolean]
      def primary_key?(attribute)
        attribute.name.to_s == model.primary_key
      end

      # @param attribute [Symbol]
      #
      # @return [Boolean]
      def inheritance_column?(attribute)
        attribute.name.to_s == model.inheritance_column
      end

      # @param attribute [Symbol]
      #
      # @return [Boolean]
      def counter_cache_column?(attribute)
        attribute.name.to_s.end_with?("_count")
      end

      # @return [Boolean]
      def array_column?(column)
        column.respond_to?(:array?) && column.array?
      end

    end
  end
end

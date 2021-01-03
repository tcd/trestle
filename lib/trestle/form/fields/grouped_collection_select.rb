module Trestle
  class Form
    module Fields
      class GroupedCollectionSelect < Field

        attr_reader :collection
        attr_reader :group_method
        attr_reader :group_label_method
        attr_reader :option_key_method
        attr_reader :option_value_method
        # @return [Hash]
        attr_reader :html_options

        # @param builder [Trestle::Form::Builder]
        # @param template [Doc::Unknown]
        # @param name [Doc::Unknown]
        # @param collection [Doc::Unknown]
        # @param group_method [Doc::Unknown]
        # @param group_label_method [Doc::Unknown]
        # @param option_key_method [Doc::Unknown]
        # @param option_value_method [Doc::Unknown]
        # @param options [Hash]
        # @param html_options [Hash]
        #
        # @return [void]
        def initialize(builder, template, name, collection, group_method, group_label_method, option_key_method, option_value_method, options={}, html_options={})
          super(builder, template, name, options)
          @collection          = collection
          @group_method        = group_method
          @group_label_method  = group_label_method
          @option_key_method   = option_key_method
          @option_value_method = option_value_method
          @html_options        = default_html_options.merge(html_options)
        end

        def field
          builder.raw_grouped_collection_select(name, collection, group_method, group_label_method, option_key_method, option_value_method, options, html_options)
        end

        # @return [void]
        def default_html_options
          Trestle::Options.new(class: ["form-control"], disabled: disabled? || readonly?, data: { enable_select2: true })
        end

      end
    end
  end
end

Trestle::Form::Builder.register(
  :grouped_collection_select,
  Trestle::Form::Fields::GroupedCollectionSelect,
)

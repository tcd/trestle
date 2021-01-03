module Trestle
  class Form
    module Fields
      class CollectionSelect < Field

        attr_reader :collection, :value_method, :text_method, :html_options

        # @return [void]
        def initialize(builder, template, name, collection, value_method, text_method, options={}, html_options={})
          super(builder, template, name, options)

          @collection   = collection
          @value_method = value_method
          @text_method  = text_method
          @html_options = default_html_options.merge(html_options)
        end

        # @return [Doc::HTML]
        def field
          builder.raw_collection_select(name, collection, value_method, text_method, options, html_options)
        end

        # @return [Trestle::Options]
        def default_html_options
          Trestle::Options.new(class: ["form-control"], disabled: disabled? || readonly?, data: { enable_select2: true })
        end

      end
    end
  end
end

Trestle::Form::Builder.register(:collection_select, Trestle::Form::Fields::CollectionSelect)

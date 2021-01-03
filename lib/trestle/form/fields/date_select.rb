module Trestle
  class Form
    module Fields
      class DateSelect < Field

        # @return [Trestle::Options]
        attr_reader :html_options

        # @return [void]
        def initialize(builder, template, name, options={}, html_options={}, &block)
          super(builder, template, name, options, &block)

          @html_options = default_html_options.merge(html_options)
        end

        # @return [Doc::HTML]
        def field
          content_tag(:div, class: "date-select") do
            builder.raw_date_select(name, options, html_options, &block)
          end
        end

        # @return [Trestle::Options]
        def default_html_options
          Trestle::Options.new(class: ["form-control"], disabled: readonly?, data: { enable_select2: true })
        end

      end
    end
  end
end

Trestle::Form::Builder.register(:date_select, Trestle::Form::Fields::DateSelect)

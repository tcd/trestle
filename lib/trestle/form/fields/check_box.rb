module Trestle
  class Form
    module Fields
      class CheckBox < Field
        include CheckBoxHelpers

        # @return [String]
        attr_reader :checked_value

        # @return [String]
        attr_reader :unchecked_value

        # @param builder [Doc::Unknown]
        # @param template [Doc::Unknown]
        # @param name [Doc::Unknown<Symbol>]
        # @param options [Hash]
        # @param checked_value [String]
        # @param unchecked_value [String]
        #
        # @return [void]
        def initialize(builder, template, name, options = {}, checked_value = "1", unchecked_value = "0")
          super(builder, template, name, options)
          @checked_value = checked_value
          @unchecked_value = unchecked_value
        end

        # @return [Doc::HTML]
        def render
          field
        end

        # @return [Doc::HTML]
        def field
          wrapper_class = options.delete(:class)
          wrapper_class = default_wrapper_class if wrapper_class.empty?

          content_tag(:div, class: wrapper_class) do
            safe_join([
              builder.raw_check_box(name, options.merge(class: input_class), checked_value, unchecked_value),
              builder.label(name, options[:label] || admin.human_attribute_name(name), class: label_class, value: (checked_value if options[:multiple])),
            ])
          end
        end

        # @return [void]
        def extract_wrapper_options!
          # Intentional no-op
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:check_box, Trestle::Form::Fields::CheckBox)

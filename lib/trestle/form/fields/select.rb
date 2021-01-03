module Trestle
  class Form
    module Fields
      class Select < Field
        attr_reader :choices, :html_options

        # @param builder [Doc::Unknown]
        # @param template [Doc::Unknown]
        # @param name [Doc::Unknown]
        # @param choices [Doc::Unknown]
        # @param options [Hash]
        # @param html_options [Hash]
        # @param &block [Proc]
        # @return [void]
        def initialize(builder, template, name, choices=nil, options={}, html_options={}, &block)
          super(builder, template, name, options, &block)

          @choices = choices || default_choices
          @choices = Choices.new(@choices) if @choices.nil? || @choices.is_a?(Enumerable)

          @html_options = default_html_options.merge(html_options)
        end

        # @return [Doc::HTML]
        def field
          builder.raw_select(name, choices, options, html_options, &block)
        end

        # @return [Trestle::Options]
        def default_html_options
          Trestle::Options.new(class: ["form-control"], disabled: disabled? || readonly?, data: { enable_select2: true })
        end

        def default_choices
          builder.object.send(name) if builder.object
        end

        # Allows an array of model instances (or a scope) to be
        # passed to the select field as the list of choices.
        class Choices
          include Enumerable
          alias empty? none?

          # @return [void]
          def initialize(choices)
            @choices = Array(choices)
          end

          def each
            @choices.each do |option|
              yield option_text_and_value(option)
            end
          end

          protected

          def option_text_and_value(option)
            if !option.is_a?(String) && option.respond_to?(:first) && option.respond_to?(:last)
              option
            elsif option.respond_to?(:id)
              [Trestle::Display.new(option).to_s, option.id]
            else
              [option, option]
            end
          end

        end
      end
    end
  end
end

Trestle::Form::Builder.register(:select, Trestle::Form::Fields::Select)

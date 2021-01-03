module Trestle
  class Form
    module Fields
      class FormGroup < Field

        # @return [Array<Symbol>]
        WRAPPER_OPTIONS = [
          :help,
          :label,
          :hide_label,
        ].freeze()

        # @param builder [Doc::Unknown]
        # @param template [Doc::Unknown]
        # @param template [Doc::Unknown<Symbol>]
        # @param options [Hash]
        # @option options [String] :help
        # @option options [Boolean] :label
        # @option options [Boolean] :hide_label
        # @param &block [Proc]
        #
        # @return [void]
        def initialize(builder, template, name=nil, options={}, &block)
          # Normalize options passed as name parameter
          if name.is_a?(Hash)
            options = name
            name    = nil
          end

          super(builder, template, name, options, &block)
        end

        # @return [Doc::Html]
        def render()
          content_tag(:div, options.except(*WRAPPER_OPTIONS)) do
            concat(label) if name && options[:label] != false
            concat(template.capture(&block)) if block
            concat(help_message) if options[:help]
            concat(error_message) if name && errors.any?
          end
        end

        # @return [Doc::Html]
        def help_message
          classes = ["form-text"]

          if options[:help].is_a?(Hash)
            message = options[:help][:text]
            classes << "floating" if options[:help][:float]
          else
            message = options[:help]
          end

          content_tag(:p, message, class: classes)
        end

        # @return [Doc::Html]
        def error_message
          content_tag(:p, class: "invalid-feedback") do
            safe_join([icon("fa fa-warning"), errors.first], " ")
          end
        end

        # @return [Doc::Html]
        def label
          builder.label(name, options[:label], class: ["control-label", ("sr-only" if options[:hide_label])].compact)
        end

        # @return [Trestle::Options]
        def defaults
          Trestle::Options.new(class: ["form-group"])
        end

        protected

        # @return [void]
        def extract_wrapper_options!
          # Intentional no-op
        end

        # @return [String]
        def error_class
          "has-error"
        end

        # @return [Array]
        def error_keys
          name ? super : []
        end

      end
    end
  end
end

Trestle::Form::Builder.register(
  :form_group,
  Trestle::Form::Fields::FormGroup,
)

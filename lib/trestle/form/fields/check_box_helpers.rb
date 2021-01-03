module Trestle
  class Form
    module Fields
      module CheckBoxHelpers

        # @return [Boolean]
        def custom?
          options[:custom] != false
        end

        # @return [Boolean]
        def switch?
          options[:switch]
        end

        # @return [Boolean]
        def inline?
          options[:inline]
        end

        # @return [Array<String>]
        def default_wrapper_class
          if custom?
            [
              "custom-control",
              switch? ? "custom-switch" : "custom-checkbox",
              ("custom-control-inline" if inline?),
            ].compact
          else
            [
              "form-check",
              ("form-check-inline" if inline?),
            ].compact
          end
        end

        # @return [Array<String>]
        def input_class
          custom? ? ["custom-control-input"] : ["form-check-input"]
        end

        # @return [Array<String>]
        def label_class
          custom? ? ["custom-control-label"] : ["form-check-label"]
        end

        # @return [Trestle::Options]
        def defaults
          Trestle::Options.new(disabled: readonly?)
        end

      end
    end
  end
end

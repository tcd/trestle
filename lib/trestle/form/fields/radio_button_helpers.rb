module Trestle
  class Form
    module Fields
      module RadioButtonHelpers

        # @return [Boolean]
        def custom?
          options[:custom] != false
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
              "custom-radio",
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

      end
    end
  end
end

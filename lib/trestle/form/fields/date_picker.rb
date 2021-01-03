module Trestle
  module Form
    module Fields
      module DatePicker

        # @return [void]
        def normalize_options!
          unless options[:prepend] == false
            options[:prepend] ||= options.delete(:icon) { default_icon }
          end

          if enable_date_picker?
            options.reverse_merge!(data: { picker: true, allow_clear: true })
          end

          super
        end

        # @return [Doc::HTML]
        def default_icon
          icon("fa fa-calendar")
        end

        # @return [Boolean]
        def enable_date_picker?
          !disabled? && !readonly? && options[:picker] != false
        end

      end
    end
  end
end

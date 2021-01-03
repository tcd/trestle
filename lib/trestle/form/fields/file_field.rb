module Trestle
  class Form
    module Fields
      class FileField < Field
        def field
          if custom?
            content_tag(:div, class: "custom-file") do
              concat builder.raw_file_field(name, options.merge(class: "custom-file-input"))
              concat builder.label(name, choose_file_text, class: "custom-file-label", data: { browse: browse_text })
            end
          else
            builder.raw_file_field(name, options)
          end
        end

        # @return [Boolean]
        def custom?
          options[:custom] != false
        end

        # @return [String]
        def choose_file_text
          I18n.t("trestle.file.choose_file", default: "Choose file...")
        end

        # @return [String]
        def browse_text
          I18n.t("trestle.file.browse", default: "Browse")
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:file_field, Trestle::Form::Fields::FileField)

module Trestle
  module StatusHelper
    # @param label [Doc::Unknown]
    # @param status [Symbol] A [Bootstrap contextual color](https://getbootstrap.com/docs/4.5/getting-started/theming/#theme-colors) (or https://getbootstrap.com/docs/4.5/utilities/colors/)
    # @param options [Hash] Options to pass to `content_tag`
    #
    # @return [String]
    def status_tag(label, status=:primary, options={})
      options[:class] ||= ["badge", "badge-#{status}"]
      content_tag(:span, label, options)
    end
  end
end

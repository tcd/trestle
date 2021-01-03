require "action_view/helpers"

module Trestle
  class Tab

    include ActionView::Helpers::TagHelper

    attr_reader :name
    attr_reader :options

    # @return [void]
    def initialize(name, options={})
      @name    = name
      @options = options
    end

    # @return [String]
    def id(tag=nil)
      ["tab", tag, name].compact.join("-")
    end

    def label
      safe_join([options[:label] || I18n.t("admin.tabs.#{name}", default: name.to_s.titleize), badge].compact, " ")
    end

    def badge
      content_tag(:span, options[:badge], class: "badge") if options[:badge]
    end

  end
end

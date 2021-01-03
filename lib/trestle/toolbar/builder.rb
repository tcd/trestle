module Trestle
  class Toolbar
    class Builder

      # @param template [Doc::Unknown]
      #
      # @return [void]
      def initialize(template)
        @template = template
      end

      # @param label [Doc::Unknown]
      # @param options [Hash]
      # @param &block [Proc]
      #
      # @return [Trestle::Toolbar::Button]
      def button(label, options={}, &block)
        Button.new(@template, label, options, &block)
      end

      # @param label [Doc::Unknown]
      # @param instance_or_url [Hash]
      # @param options [Hash]
      # @param &block [Proc]
      #
      # @return [Trestle::Toolbar::Link]
      def link(label, instance_or_url={}, options={}, &block)
        Link.new(@template, label, instance_or_url, options, &block)
      end

      # @param label [Doc::Unknown]
      # @param options [Hash]
      # @param &block [Proc]
      #
      # @return [Trestle::Toolbar::Dropdown]
      def dropdown(label=nil, options={}, &block)
        Dropdown.new(@template, label, options, &block)
      end

      # Only methods explicitly tagged as builder methods will be automatically
      # appended to the toolbar when called by Toolbar::Context.
      class_attribute(:builder_methods)

      self.builder_methods = []

      # @param *methods [Array]
      #
      # @return [void]
      def self.builder_method(*methods)
        self.builder_methods += methods
      end

      builder_method(:button, :link, :dropdown)
    end
  end
end

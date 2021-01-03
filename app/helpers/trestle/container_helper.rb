module Trestle
  module ContainerHelper

    # @param &block [Proc]
    #
    # @return [Trestle::Doc::HTML]
    def container(&block)
      context = Context.new(self)
      content = capture(context, &block)

      content_tag(:div, class: "main-content-container") do
        concat(content_tag(:div, content, class: "main-content"))
        concat(content_tag(:aside, context.sidebar, class: "main-content-sidebar")) unless context.sidebar.blank?
      end
    end

    class Context

      # @!attribute template [rw]
      #   @return [Doc::Unknown]

      # @!attribute sidebar [rw]
      #   @return [Doc::Unknown]

      # @return [void]
      def initialize(template)
        @template = template
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def sidebar(&block)
        @sidebar = @template.capture(&block) if block_given?
        @sidebar
      end
    end
  end
end

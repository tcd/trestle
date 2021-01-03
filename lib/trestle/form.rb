module Trestle
  class Form
    require_relative "form/automatic"
    require_relative "form/builder"
    require_relative "form/field"
    require_relative "form/fields"
    require_relative "form/renderer"

    # @return [Options]
    attr_reader :options

    # @return [Proc]
    attr_reader :block

    # @param options [Hash]
    # @param &block [Proc]
    #
    # @return [void]
    def initialize(options={}, &block)
      @options = options
      @block   = block
    end

    # @return [Boolean]
    def dialog?
      options[:dialog] == true
    end

    # @param template [Doc::Unknown]
    # @param instance [Object]
    #
    # @return [Doc::HTML]
    def render(template, instance)
      Renderer.new(template).render_form(instance, &block)
    end
  end
end

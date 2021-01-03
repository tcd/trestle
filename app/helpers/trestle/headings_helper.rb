module Trestle
  module HeadingsHelper

    # @param text [String]
    # @param options [Hash]
    #
    # @return [Doc::HTML]
    def h1(text, options={})
      content_tag(:h1, text, options)
    end

    # @param text [String]
    # @param options [Hash]
    #
    # @return [Doc::HTML]
    def h2(text, options={})
      content_tag(:h2, text, options)
    end

    # @param text [String]
    # @param options [Hash]
    #
    # @return [Doc::HTML]
    def h3(text, options={})
      content_tag(:h3, text, options)
    end

    # @param text [String]
    # @param options [Hash]
    #
    # @return [Doc::HTML]
    def h4(text, options={})
      content_tag(:h4, text, options)
    end

    # @param text [String]
    # @param options [Hash]
    #
    # @return [Doc::HTML]
    def h5(text, options={})
      content_tag(:h5, text, options)
    end

    # @param text [String]
    # @param options [Hash]
    #
    # @return [Doc::HTML]
    def h6(text, options={})
      content_tag(:h6, text, options)
    end

  end
end

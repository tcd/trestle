module Trestle
  module GridHelper
    # Renders a row div, one of the building blocks of Bootstrap's [grid system][1].
    #
    # [1]: https://getbootstrap.com/docs/4.4/layout/grid/
    #
    # @example
    #   <%= row do %>
    #     <%= col do %>Column content<% end %>
    #   <% end %>
    #
    # @example
    #   <%= row class: "row-cols-2", id: "my-row" do %> ...
    #
    # @param attrs [Hash] Hash of attributes that will be passed to the tag (e.g. id, data, class).
    #
    # @return [Trestle::Doc::HTML] An HTML-safe String.
    def row(attrs={})
      defaults = Trestle::Options.new(class: ["row"])
      options = defaults.merge(attrs)

      content_tag(:div, options) { yield }
    end

    # Renders a column div, one of the building blocks of Bootstrap's [grid system][1].
    #
    # [1]: https://getbootstrap.com/docs/4.4/layout/grid/
    #
    # Column divs should always be rendered inside of a row div.
    #
    # @example
    #   # Standard column - evenly fills available space
    #   <%= col do %>...<% end %>
    #
    # @example
    #   # Column spans 4 (out of 12) grid columns (i.e. 1/3 width) at all breakpoints
    #   <%= col 4 do %> ...
    #
    # @example
    #   # Column spans 6 grid columns at smallest breakpoint, 4 at md breakpoint
    #   # and above (portrait tablet) and 3 at xl breakpoint and above (desktop)
    #   <%= col 6, md: 4, xl: 3 do %> ...
    #
    # @param columns [Hash]
    # @param breakpoints [Hash]
    #
    # @return [Trestle::Doc::HTML] An HTML-safe String.
    def col(columns=nil, breakpoints={})
      if columns.is_a?(Hash)
        breakpoints = columns
        columns = breakpoints.delete("xs") || breakpoints.delete(:xs)
      end

      if columns.nil? && breakpoints.empty?
        classes = "col"
      else
        classes = []
        classes << "col-#{columns}" if columns
        classes += breakpoints.map { |breakpoint, span| "col-#{breakpoint}-#{span}" }
      end

      content_tag(:div, class: classes) { yield }
    end

    # Renders an `<hr>` (horizontal rule) HTML tag.
    #
    # @param attrs [Hash] Hash of attributes that will be passed to the tag (e.g. id, data, class).
    #
    # @return [Trestle::Doc::HTML] An HTML-safe String.
    def divider(attrs={})
      tag(:hr, attrs)
    end
  end
end

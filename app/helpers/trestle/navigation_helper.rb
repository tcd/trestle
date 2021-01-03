module Trestle
  module NavigationHelper

    # @param item [Doc::Unknown]
    #
    # @return [Boolean]
    def current_navigation_item?(item)
      current_page?(item.path) || (item.admin && current_admin?(item.admin))
    end

    # @param admin [Doc::Unknown]
    #
    # @return [Boolean]
    def current_admin?(admin)
      respond_to?(:admin) && self.admin && self.admin.name == admin.name
    end

  end
end

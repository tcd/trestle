module Trestle
  module TitleHelper
    # @return [String]
    def title
      content_for(:title) || default_title
    end

    # @return [String]
    def default_title
      action_name.titleize
    end
  end
end

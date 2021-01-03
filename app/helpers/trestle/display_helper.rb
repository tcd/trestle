module Trestle
  module DisplayHelper
    # @param instance [Doc::Unknown]
    # @return [String]
    def display(instance)
      Trestle::Display.new(instance).to_s
    end
  end
end

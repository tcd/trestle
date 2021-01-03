module Trestle
  class Display

    # @param instance [Object]
    # @return [void]
    def initialize(instance)
      @instance = instance
    end

    # @return [String]
    def to_s
      if display_method != :to_s || @instance.method(display_method).source_location
        @instance.public_send(display_method)
      else
        "#{@instance.class} (##{@instance.id})"
      end
    end

    private

    # @return [String]
    def display_method
      @display_method ||= Trestle.config.display_methods.find { |m| @instance.respond_to?(m) } || :to_s
    end

  end
end

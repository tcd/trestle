module Trestle
  # Descendant of Hash.
  class Options < Hash

    # @!attribute hash [rw]
    #   @return [Hash]

    # @param hash [Hash]
    #
    # @return [void]
    def self.new(hash={})
      self[hash]
    end

    # @param other [Hash]
    # @param &block [Proc]
    #
    # @return [Options]
    def merge(other, &block)
      dup.merge!(other, &block)
    end

    # @param other [Hash]
    # @param &block [Proc]
    #
    # @return [Options]
    def merge!(other, &block)
      super(other || {}) do |_key, v1, v2|
        if v1.is_a?(Hash) && v2.is_a?(Hash)
          v1.merge(v2, &block)
        elsif v1.is_a?(Array)
          v1 + Array(v2)
        else
          v2
        end
      end
    end

  end
end

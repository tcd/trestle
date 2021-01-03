module Trestle
  class Breadcrumb

    attr_reader :label
    attr_reader :path

    # @param label [Doc::Unknown]
    # @param path [Doc::Unknown]
    # @return [void]
    def initialize(label, path=nil)
      @label = label
      @path  = path
    end

    # @param other [#label, #path]
    # @return [Boolean]
    def ==(other)
      label == other.label && path == other.path
    end

    # @raise [ArgumentError]
    # @param object [Object]
    # @return [Trestle::Breadcrumb]
    def self.cast(obj)
      case obj
      when Breadcrumb
        obj
      when String
        new(obj)
      when Array
        new(*obj)
      when NilClass, false
        nil
      else
        raise ArgumentError, "Unable to cast #{obj.inspect} to Breadcrumb"
      end
    end

    class Trail
      include Enumerable

      # @param breadcrumbs [Array]
      # @return [void]
      def initialize(breadcrumbs=[])
        @breadcrumbs = Array(breadcrumbs).compact
      end

      # @param other [#to_a]
      # @return [Boolean]
      def ==(other)
        to_a == other.to_a
      end

      def dup
        self.class.new(@breadcrumbs.dup)
      end

      # @param label [Doc::Unknown]
      # @param path [Doc::Unknown]
      # @return [void]
      def append(label, path=nil)
        @breadcrumbs << Breadcrumb.new(label, path)
      end

      # @param label [Doc::Unknown]
      # @param path [Doc::Unknown]
      # @return [void]
      def prepend(label, path=nil)
        @breadcrumbs.unshift(Breadcrumb.new(label, path))
      end

      delegate :each, :first, :last, to: :@breadcrumbs
    end
  end
end

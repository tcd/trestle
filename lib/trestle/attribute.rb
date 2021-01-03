module Trestle
  class Attribute

    # @return [Symbol]
    attr_reader :name

    # @return [Symbol]
    attr_reader :type

    # @return [Hash]
    attr_reader :options

    # @param name [Symbol]
    # @param type [Symbol]
    # @param options [Hash]
    # @return [void]
    def initialize(name, type, options={})
      @name    = name.to_sym
      @type    = type
      @options = options
    end

    # @return [Boolean]
    def array?
      options[:array] == true
    end

    class Association < Attribute
      # @param name [Symbol]
      # @param options [Hash]
      # @return [void]
      def initialize(name, options={})
        super(name, :association, options)
      end

      # @return [String]
      def association_name
        options[:name] || name.to_s.sub(/_id$/, "")
      end

      def association_class
        options[:class].respond_to?(:call) ? options[:class].call : options[:class]
      end

      # @return [Boolean]
      def polymorphic?
        options[:polymorphic] == true
      end
    end

  end
end

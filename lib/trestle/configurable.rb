module Trestle
  module Configurable
    extend ActiveSupport::Concern

    delegate(:defaults, to: :class)

    def configure(&block)
      yield self if block_given?
      self
    end

    # @param name [Symbol]
    def fetch(name)
      name = name.to_sym

      options.fetch(name) {
        if defaults.key?(name)
          value = defaults[name]
          assign(name, value)
        end
      }
    end

    # @param name [Symbol]
    # @param value [Object]
    def assign(name, value)
      options[name.to_sym] = value
    end

    # @return [Hash]
    def options
      @options ||= {}
    end

    def as_json(options=nil)
      @options.each_with_object({}) do |(k, v), h|
        h[k] = v.as_json(options)
      end
    end

    # @return [String]
    def inspect
      "#<#{self.class.name || 'Anonymous(Trestle::Configurable)'}>"
    end

    module ClassMethods

      def defaults
        @defaults ||= {}
      end

      # @param name [Symbol]
      # @param default [Doc::Unknown]
      # @param Opts [Hash]
      def option(name, default=nil, opts={})
        name = name.to_sym

        define_method("#{name}=") do |value|
          assign(name, value)
        end

        define_method(name) do |*args|
          value = fetch(name)

          if value.respond_to?(:call) && opts[:evaluate] != false
            value = value.call(*args)
          end

          value
        end

        defaults[name] = default
      end

      def deprecated_option(name, message=nil)
        define_method("#{name}=") do |value|
          ActiveSupport::Deprecation.warn(message)
        end

        define_method(name) do |*args|
          ActiveSupport::Deprecation.warn(message)
        end
      end

    end

    module Open

      protected

      # @return [Boolean]
      def respond_to_missing(_name, _include_all=false)
        true
      end

      # @return [Boolean]
      def respond_to_missing?(*_args)
        return true
      end

      # @param name [String]
      # @param *args [Doc::Unknown]
      # @param &block [Proc]
      # @return [Doc::Unknown]
      def method_missing(name, *args, &block)
        if name =~ /(.*)\=$/
          key, value = $1, args.first
          options[key.to_sym] = value
        else
          options[name.to_sym] ||= self.class.new
        end
      end

    end

  end
end

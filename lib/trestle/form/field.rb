module Trestle
  class Form
    class Field

      attr_reader :builder
      attr_reader :template

      # @return [Doc::Unknown<Symbol>]
      attr_reader :name

      # @return [Trestle::Options]
      attr_reader :options

      # @return [Proc]
      attr_reader :block

      delegate(
        :admin,
        :content_tag,
        :concat,
        :safe_join,
        :icon,
        to: :template,
      )

      # @param builder [Doc::Unknown]
      # @param template [Doc::Unknown]
      # @param name [Doc::Unknown<Symbol>]
      # @param options [Hash]
      # @option options [Boolean] :disabled
      # @option options [Boolean] :readonly
      # @option options [Doc::Unknown] :class
      # @option options [Doc::Unknown] :wrapper
      # @param &block [Proc]
      #
      # @return [void]
      def initialize(builder, template, name, options={}, &block)
        @builder  = builder
        @template = template
        @name     = name
        @block    = block

        assign_options!(options)
        normalize_options!()
      end

      # @return [Array]
      def errors
        return error_keys.map { |key| builder.errors(key) }.flatten
      end

      # @param opts [Hash]
      #
      # @return [Doc::Unknown]
      def form_group(opts={})
        if @wrapper
          @builder.form_group(name, @wrapper.merge(opts)) do
            yield
          end
        else
          yield
        end
      end

      def render
        return form_group { field }
      end

      def field
        raise NotImplementedError
      end

      # @return [Trestle::Options]
      def defaults
        return Trestle::Options.new(readonly: readonly?)
      end

      # @return [Boolean]
      def disabled?
        return options[:disabled]
      end

      # @return [Boolean]
      def readonly?
        return options[:readonly] || admin.readonly?
      end

      # @return [void]
      def normalize_options!
        extract_wrapper_options!()
        assign_error_class!()
      end

      protected

      # @param options [Hash]
      #
      # @return [void]
      def assign_options!(options)
        # Assign @options first so that it can be referenced from within {#defaults} if required
        @options = Trestle::Options.new(options)
        @options = defaults.merge(options)
      end

      # @return [void]
      def extract_wrapper_options!
        wrapper = options.delete(:wrapper)

        unless wrapper == false
          @wrapper = extract_options(*Fields::FormGroup::WRAPPER_OPTIONS)
          @wrapper.merge!(wrapper) if wrapper.is_a?(Hash)
        end
      end

      # @return [void]
      def assign_error_class!
        @options[:class] = Array(@options[:class])
        @options[:class] << error_class if errors.any?
      end

      # @return [String]
      def error_class
        return "is-invalid"
      end

      # @return [Array]
      def error_keys
        keys = [name]
        # Singular associations (belongs_to)
        keys << name.to_s.sub(/_id$/, '') if name.to_s =~ /_id$/
        # Collection associations (has_many / has_and_belongs_to_many)
        keys << name.to_s.sub(/_ids$/, 's') if name.to_s =~ /_ids$/
        return keys
      end

      # @param *keys [Array<Symbol>]
      #
      # @return [Trestle::Options]
      def extract_options(*keys)
        extracted = Trestle::Options.new
        keys.each { |k| extracted[k] = options.delete(k) if options.key?(k) }
        return extracted
      end

    end
  end
end

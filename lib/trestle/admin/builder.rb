module Trestle
  class Admin
    class Builder < Trestle::Builder

      # @!attribute admin [rw]
      #   @return [Doc::Unknown]

      # @!attribute controller [rw]
      #   @return [Doc::Unknown]

      target(:admin)

      class_attribute(:admin_class)
      self.admin_class = Admin

      class_attribute(:controller)
      self.controller = -> { AdminController }

      delegate(:helper, :before_action, :after_action, :around_action, to: :@controller)

      # @param admin [Doc::Unknown]
      # @return [void]
      def initialize(admin)
        @admin      = admin
        @controller = admin.const_get(:AdminController)
      end

      # @param name [Symbol]
      # @param options [Hash]
      # @param &block [Proc]
      #
      # @return [Class]
      def self.create(name, options={}, &block)
        # Create admin subclass
        admin = Class.new(admin_class)
        admin.options = options

        # Define a constant based on the admin name
        scope = options[:scope] || Object
        scope.const_set("#{name.to_s.camelize}Admin", admin)

        # Define admin controller class
        # This is done using `class_eval` rather than `Class.new` so that the full
        # class name and parent chain is set when Rails' inherited hooks are called.
        admin.class_eval("class AdminController < #{controller.call.name}; end", __FILE__, __LINE__)

        # Set a reference on the controller class to the admin class
        controller = admin.const_get(:AdminController)
        controller.instance_variable_set("@admin", admin)

        admin.build(&block)
        admin.validate!

        admin
      end

      # @param *args [Array<Object>]
      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def menu(*args, &block)
        if block_given?
          admin.menu = Navigation::Block.new(admin, &block)
        else
          menu { item(*args) }
        end
      end

      # @param name_or_options [Hash]
      # @param options [Hash]
      # @param &block [Proc]
      #
      # @return [void]
      def table(name_or_options={}, options={}, &block)
        name, options = normalize_table_options(name_or_options, options)
        admin.tables[name] = Table::Builder.build(options, &block)
      end

      # @param options [Hash]
      # @param &block [Proc]
      #
      # @return [void]
      def form(options={}, &block)
        if block_given?
          admin.form = Form.new(options, &block)
        else
          admin.form = Form::Automatic.new(admin, options)
        end
      end

      # @param name [Doc::Unknown<Symbol>]
      # @param options [Hash]
      # @param &block [Proc]
      #
      # @return [void]
      def hook(name, options={}, &block)
        admin.hooks.append(name, options, &block)
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def admin(&block)
        @admin.instance_eval(&block) if block_given?
        return @admin
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def controller(&block)
        @controller.class_eval(&block) if block_given?
        return @controller
      end

      # @param &block [Proc]
      #
      # @return [void]
      def routes(&block)
        @admin.additional_routes << block
      end

      # @param label [Doc::Unknown<Symbol>]
      # @param path [Doc::Unknown<String>]
      # @param &block [Proc]
      #
      # @return [void]
      def breadcrumb(label=nil, path=nil, &block)
        if block_given?
          @admin.breadcrumb = block
        elsif label
          @admin.breadcrumb = -> { Breadcrumb.new(label, path) }
        else
          @admin.breadcrumb = -> { false }
        end
      end

      protected

      # @param name [Object]
      # @param options [Object]
      #
      # @return [Array]
      def normalize_table_options(name, options)
        if name.is_a?(Hash)
          options = name.dup
          name    = :index
        end
        return [name, options]
      end

    end
  end
end

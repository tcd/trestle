module Trestle
  class Admin

    require_relative "admin/builder"

    delegate(:to_param, to: :class)

    # @param context [Doc::Unknown]
    #
    # @return [void]
    def initialize(context=nil)
      @context = context
    end

    # Delegate all missing methods to corresponding class method if available
    #
    # @param name [Symbol]
    # @param *args [Array<Object>]
    # @param &block [Proc]
    #
    # @return [Doc::Unknown]
    def method_missing(name, *args, &block)
      if self.class.respond_to?(name)
        self.class.send(name, *args, &block)
      else
        super
      end
    end

    # @param name [Symbol]
    # @param include_private [Boolean]
    #
    # @return [Boolean]
    def respond_to_missing?(name, include_private=false)
      self.class.respond_to?(name, include_private) || super
    end

    class << self
      attr_accessor :menu

      attr_accessor :form

      attr_writer :options
      attr_writer :breadcrumb

      # @return [Hash]
      def options
        @options ||= {}
      end

      # @return [Hash]
      def tables
        @tables ||= {}
      end

      # @return [Trestle::Hook::Set]
      def hooks
        @hooks ||= Hook::Set.new
      end

      # @deprecated Use `tables[:index]` instead
      def table
        tables[:index]
      end

      # @deprecated Use `tables[:index]=` instead
      def table=(table)
        tables[:index] = table
      end

      # @return [Trestle::Breadcrumb::Trail]
      def breadcrumbs
        Breadcrumb::Trail.new(Array(Trestle.config.root_breadcrumbs) + [breadcrumb])
      end

      # @return [Trestle::Breadcrumb]
      def breadcrumb
        if @breadcrumb
          Breadcrumb.cast(@breadcrumb.call)
        else
          default_breadcrumb
        end
      end

      # @return [Trestle::Breadcrumb]
      def default_breadcrumb
        deprecated = I18n.t(:"admin.breadcrumbs.#{i18n_key}", default: human_admin_name)
        label = translate("breadcrumbs.index", default: deprecated)

        Breadcrumb.new(label, path)
      end

      # @return [String]
      def admin_name
        name.underscore.sub(/_admin$/, '')
      end

      # @return [String]
      def i18n_key
        admin_name
      end

      # @return [String]
      def human_admin_name
        translate("name", default: default_human_admin_name)
      end

      # @return [String]
      def default_human_admin_name
        name.demodulize.underscore.sub(/_admin$/, '').titleize
      end

      # @return [String]
      def translate(key, options={})
        defaults = [:"admin.#{i18n_key}.#{key}", :"admin.#{key}"]
        defaults << options[:default] if options[:default]

        I18n.t(defaults.shift, **options.merge(default: defaults))
      end
      # @!method quit(key, options={})
      #   @param key [Doc::Unknown]
      #   @param message [Hash]
      #   @return [String]
      alias t translate
      # @!parse
      #   # (see #translate)
      #   def self.t(key, options={}); end

      # @return [String]
      def parameter_name
        unscope_path(admin_name.singularize)
      end

      # @return [String]
      def route_name
        "#{admin_name.tr('/', '_')}_admin"
      end

      attr_writer :view_path

      # @return [String]
      def view_path
        @view_path || default_view_path
      end

      # @return [String]
      def default_view_path
        "admin/#{name.underscore.sub(/_admin$/, '')}"
      end

      # @return [Array<String>]
      def view_path_prefixes
        [view_path]
      end

      # @return [String]
      def controller_namespace
        "#{name.underscore}/admin"
      end

      # @param action [Doc::Unknown]
      # @param options [Hash]
      #
      # @return [Doc::Unknown]
      def path(action=root_action, options={})
        Engine.routes.url_for(options.merge(controller: controller_namespace, action: action, only_path: true))
      end

      # @raise [NoMethodError]
      def to_param(*)
        raise NoMethodError, "#to_param called on non-resourceful admin. You may need to explicitly specify the admin."
      end

      # @return [Array<Symbol>]
      def actions
        [:index]
      end

      # @return [Symbol]
      def root_action
        :index
      end

      # @return [Array]
      def additional_routes
        @additional_routes ||= []
      end

      # @return [Proc]
      def routes
        admin = self

        proc do
          scope(controller: admin.controller_namespace, path: admin.options[:path] || admin.admin_name) do
            get("", action: "index", as: admin.route_name)

            admin.additional_routes.each do |block|
              instance_exec(&block)
            end
          end
        end
      end

      # @param include_path_helpers [Boolean]
      #
      # @return [Doc::Unknown]
      def railtie_routes_url_helpers(include_path_helpers=true)
        Trestle.railtie_routes_url_helpers(include_path_helpers)
      end

      # @param &block [Proc]
      #
      # @return [Doc::Unknown]
      def build(&block)
        Admin::Builder.build(self, &block)
      end

      def validate!
        # No validations by default. This can be overridden in subclasses.
      end

      private

      # @param path [Symbol,String]
      # @return [String]
      def unscope_path(path)
        path = path.to_s
        if (i = path.rindex("/"))
          path[(i + 1)..-1]
        else
          path
        end
      end

    end
  end
end

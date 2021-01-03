module Trestle
  class Table
    class ActionsColumn

      attr_reader :toolbar

      attr_reader :options

      # @param options [Hash]
      # @param &block [Proc]
      #
      # @return [void]
      def initialize(options={}, &block)
        @options = options
        @toolbar = Toolbar.new(ActionsBuilder)

        if block_given?
          @toolbar.append(&block)
        else
          @toolbar.append(&default_actions)
        end
      end

      def renderer(table:, template:)
        Renderer.new(self, table: table, template: template)
      end

      def default_actions
        ->(toolbar, instance, admin) do
          toolbar.delete if admin&.actions&.include?(:destroy)
        end
      end

      class ActionsBuilder < Toolbar::Builder

        attr_reader :instance

        attr_reader :admin

        # @param template [Doc::Unknown]
        # @param instance [Doc::Unknown]
        # @param admin [Admin]
        #
        # @return [void]
        def initialize(template, instance, admin)
          super(template)
          @instance = instance
          @admin    = admin
        end

        # @return [Trestle::Toolbar::Link]
        def show
          link(
            t("buttons.show", default: "Show"),
            instance,
            admin: admin,
            action: :show,
            icon: "fa fa-info",
            style: :info,
          )
        end

        # @return [Trestle::Toolbar::Link]
        def edit
          link(
            t("buttons.edit", default: "Edit"),
            instance,
            admin: admin,
            action: :edit,
            icon: "fa fa-pencil",
            style: :warning,
          )
        end

        # @return [Trestle::Toolbar::Link]
        def delete
          link(
            t("buttons.delete", default: "Delete"),
            instance,
            admin: admin,
            action: :destroy,
            method: :delete,
            icon: "fa fa-trash",
            style: :danger,
            data: { toggle: "confirm-delete", placement: "left" },
          )
        end

        builder_method(:show, :edit, :delete)

        # Disallow button tags within the actions toolbar. Alias to link for backwards compatibility.
        alias button link

        private

        # @return [String]
        def translate(key, options={})
          if admin
            admin.translate(key, options)
          else
            I18n.t(:"admin.#{key}", options)
          end
        end

        alias t translate

      end

      class Renderer < Column::Renderer
        def header
          options[:header]
        end

        def classes
          super + ["actions"]
        end

        def content(instance)
          @template.render_toolbar(@column.toolbar, instance, @table.admin)
        end
      end

    end
  end
end

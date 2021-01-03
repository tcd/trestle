module Trestle
  class Resource
    module Toolbar
      class Builder < Trestle::Toolbar::Builder

        delegate(:admin, :instance, to: :@template)

        # @!method translate
        #   @see Admin#translate
        delegate(:translate, to: :admin)

        # @!method t
        #   @see Admin#translate
        delegate(:t, to: :admin)

        def new
          if action?(:new)
            link(t("buttons.new", default: "New %{model_name}"), action: :new, style: :light, icon: "fa fa-plus", class: "btn-new-resource")
          end
        end

        def save
          button(t("buttons.save", default: "Save %{model_name}"), style: :success)
        end

        def delete
          if action?(:destroy)
            link(t("buttons.delete", default: "Delete %{model_name}"), instance, action: :destroy, method: :delete, style: :danger, icon: "fa fa-trash", data: { toggle: "confirm-delete", placement: "bottom" })
          end
        end

        def dismiss
          if @template.dialog_request?
            button(t("buttons.ok", default: "OK"), style: :light, data: { dismiss: "modal" })
          end
        end
        alias ok dismiss

        # @param action [Symbol]
        # @return [Doc::Unknown]
        def save_or_dismiss(action=:update)
          if action?(action)
            save
          else
            dismiss
          end
        end

        builder_method(
          :new,
          :save,
          :delete,
          :dismiss,
          :ok,
          :save_or_dismiss,
        )

        protected

        # @param action [Symbol]
        #
        # @return [Boolean]
        def action?(action)
          admin.actions.include?(action)
        end

      end
    end
  end
end

module Trestle
  module Adapters
    class Adapter

      include EvaluationContext

      # @return [Doc::Unknown]
      attr_reader :admin

      delegate(:model, to: :admin)

      # @param admin [Doc::Unknown]
      # @param context [Doc::Unknown]
      #
      # @return [void]
      def initialize(admin, context=nil)
        @admin   = admin
        @context = context
      end

      # Loads the initial collection for use by the index action.
      #
      # @param params [Hash] Unfiltered params hash from the controller
      #
      # @return [Doc::Unknown] a scope object that can be chained with other methods (e.g. sort, paginate, count, etc).
      def collection(params={})
        raise NotImplementedError
      end

      # Finds (and returns) an individual instance for use by the show, edit, update, destroy actions.
      #
      # @param params [Hash] Unfiltered params hash from the controller
      #
      # @return [Object]
      def find_instance(params)
        raise NotImplementedError
      end

      # Builds (and returns) a new instance for new/create actions.
      #
      # @param attrs [Hash] Permitted attributes to set on the new instance
      # @param params [Hash] Unfiltered params hash from the controller
      #
      # @return [Object]
      def build_instance(attrs={}, params={})
        raise NotImplementedError
      end

      # Updates (but does not save) a given resource's attributes.
      #
      # @param instance [Object] The instance to update
      # @param attrs [Hash] Permitted attributes to set on the new instance
      # @param params [Hash] Unfiltered params hash from the controller
      #
      # @return [void] The return value is ignored.
      def update_instance(instance, attrs, params={})
        raise NotImplementedError
      end

      # Saves an instance (used by the create and update actions).
      #
      # @param instance [Object] The instance to save
      # @param params [Hash] Unfiltered params hash from the controller
      #
      # @return [Boolean] A boolean indicating the success/fail status of the save.
      def save_instance(instance, params={})
        raise NotImplementedError
      end

      # Deletes an instance (used by the destroy action).
      #
      # @param instance [Object] The instance to save
      # @param params [Hash] Unfiltered params hash from the controller
      #
      # @return [Boolean] A boolean indicating the success/fail status of the deletion.
      def delete_instance(instance, params={})
        raise NotImplementedError
      end

      # Finalizes a collection so that it can be rendered within the index view.
      #
      # In most cases (e.g. ActiveRecord), no finalization is required.
      # However if you are using a search library then you may need to explicitly
      # execute the search, or access the models via a `#records` or `#objects` method.
      #
      # @param collection [Doc::Unknown] The collection to finalize
      #
      # @return [Array] An enumerable collection of instances.
      def finalize_collection(collection)
        collection
      end

      # Decorates a collection for rendering by the index view.
      #
      # Decorating is the final step in preparing the collection for the view.
      #
      # @param collection [Doc::Unknown] The collection to decorate
      #
      # @return [Array] An enumerable collection of instances.
      def decorate_collection(collection)
        collection
      end

      # Converts an instance to a URL parameter.
      # The result of this method is passed to the `#find_instance` adapter method as `params[:id]`.
      # It is recommended to simply use the instance's `#id`, as other potential options
      # such as a permalink/slug could potentially be changed during editing.
      #
      # @param instance [Object] The instance to convert
      #
      # @return The URL representation of the instance.
      def to_param(instance)
        instance.id
      end

      # Merges scopes together for Trestle scope application and counting.
      #
      # @param scope [Doc::Unknown] The first scope
      # @param other [Doc::Unknown] The second scope
      #
      # @return A scope object representing the combination of the two given scopes.
      def merge_scopes(scope, other)
        raise NotImplementedError
      end

      # Counts the number of objects in a collection for use by scope links.
      #
      # @param collection [Doc::Unknown] The collection to count
      #
      # @return [Integer] The total number of objects in the collection.
      def count(collection)
        raise NotImplementedError
      end

      # Sorts the collection by the given field and order.
      # This method is called when an explicit sort column for the given field is not defined.
      #
      # @param collection [Doc::Unknown] The collection to sort
      # @param field [Doc::Unknown] The field to sort by
      # @param order [Symbol<:asc, :desc>] Symbol (:asc or :desc) representing the sort order (ascending or descending)
      #
      # @return A scope object
      def sort(collection, field, order)
        raise NotImplementedError
      end

      # Paginates a collection for use by the index action.
      #
      # @param collection [Doc::Unknown] The collection to paginate
      # @param params [Hash] Unfiltered params hash from the controller
      # @option params [String] :page current page number
      #
      # @return A Kaminari-compatible scope corresponding to a single page.
      def paginate(collection, params)
        unless collection.respond_to?(Kaminari.config.page_method_name)
          collection = Kaminari.paginate_array(collection.to_a)
        end
        per_page = admin.pagination_options[:per]

        collection.public_send(Kaminari.config.page_method_name, params[:page]).per(per_page)
      end

      # Filters the submitted form parameters and returns a whitelisted attributes 'hash' that can be set or updated on a model instance.
      #
      # **IMPORTANT:** By default, all params are permitted, which assumes a trusted administrator.
      # If this is not the case, a `params` block should be individually declared for each admin with the set of permitted parameters.
      #
      # @param params [Hash] Unfiltered params hash from the controller
      #
      # @return [ActionController::Parameters] The permitted set of parameters.
      def permitted_params(params)
        params.require(admin.parameter_name).permit!
      end

      # Produces a human-readable name for a given attribute, applying I18n where appropriate.
      #
      # See [ActiveModel::Translation][1] for an implementation of this method.
      #
      # [1]: https://api.rubyonrails.org/classes/ActiveModel/Translation.html
      #
      # @param attribute [Symbol] Attribute name
      # @param options [Hash] Hash of options. (Not currently used)
      #
      # @return [String] The human-readable name of the given attribute.
      def human_attribute_name(attribute, options={})
        attribute.to_s.titleize
      end

      # Generates a list of attributes that should be rendered by the index (table) view.
      #
      # @return [Array<Trestle::Attribute>]
      # @return [Array<Trestle::Attribute::Association>]
      def default_table_attributes
        raise NotImplementedError
      end

      # Generates a list of attributes that should be rendered by the new/show/edit (form) views.
      #
      # @return [Array<Trestle::Attribute>, Array<Trestle::Attribute::Association>]
      def default_form_attributes
        raise NotImplementedError
      end

    end
  end
end

module Trestle
  class Table
    class Automatic < Table

      # @param admin [Admin]
      #
      # @return [void]
      def initialize(admin)
        super(sortable: true, admin: admin)
      end

      # @return [Array]
      def columns
        content_columns + [actions_column]
      end

      def content_columns
        admin.default_table_attributes.map.with_index do |attribute, index|
          case attribute.type
          when :association
            Column.new(attribute.association_name, sort: false)
          else
            Column.new(attribute.name, link: index.zero?, align: (:center if [:datetime, :boolean].include?(attribute.type)))
          end
        end
      end

      def actions_column
        ActionsColumn.new
      end
    end
  end
end

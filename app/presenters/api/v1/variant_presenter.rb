module Api
  module V1
    class VariantPresenter
      attr_reader :variant

      def self.as_json(variant)
        new(variant).as_json
      end

      def initialize(variant)
        @variant = variant
      end

      def as_json
        json = variant.as_json(only: [:id, :name, :description, :price], methods: [:price])

        variant.option_values.each do |value|
          value_name = value.name
          type_name = standard_key(value.option_type.name)
          json[type_name] = [] unless json.key?(type_name)
          json[type_name] << value_name
        end

        json
      end

    private

      def standard_key(key)
        I18n.transliterate(key.pluralize).gsub(/[^0-9A-z]/, '-')
      end
    end
  end
end

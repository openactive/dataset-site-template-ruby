require 'mustache'

module OpenActive
  module DatasetSite
    class TemplateRenderer < Mustache
      self.template_file = "#{__dir__}/datasetsite.mustache"

      def initialize(settings)
        @settings = settings
      end

      def dataset
        @dataset = @settings.to_dataset
      end

      def json
        dataset.to_json(schema: true)
      end

      def method_missing(orig_method_name, *args)
        method_name = orig_method_name.to_s.underscore

        return super unless dataset.respond_to?(method_name)

        val = dataset.public_send(method_name, *args)

        OpenActive::Helpers::JsonLd.serialize_value(val, nil)
      end

      def respond_to_missing?(orig_method_name, include_private = false)
        method_name = orig_method_name.to_s.underscore

        dataset.respond_to?(method_name) || super
      end
    end
  end
end

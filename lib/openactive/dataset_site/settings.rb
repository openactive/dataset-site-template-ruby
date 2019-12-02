module OpenActive
  module DatasetSite
    class Settings
      def initialize(**params)
        params.each do |k, v|
          setter_method = "#{k}="

          raise ArgumentError, "Unrecognised field #{k}" unless respond_to?(setter_method)

          public_send(setter_method, v)
        end
      end

      attr_accessor :open_data_feed_base_url

      attr_accessor :dataset_site_url
      attr_accessor :dataset_discussion_url
      attr_accessor :dataset_documentation_url
      attr_accessor :dataset_languages

      attr_accessor :organisation_name
      attr_accessor :organisation_legal_entity
      attr_accessor :organisation_plain_text_description
      attr_accessor :organisation_email
      attr_accessor :organisation_url
      attr_accessor :organisation_logo_url

      attr_accessor :background_image_url
      attr_accessor :date_first_published

      attr_accessor :platform_name
      attr_accessor :platform_url
      attr_accessor :platform_software_version

      attr_accessor :data_feed_types

      def data_feed_descriptions
        data_feed_types.map do |description|
          description.respond_to?(:display_name) ? description.display_name : description
        end.uniq
      end

      def name
        "#{organisation_name} #{data_feed_descriptions.to_sentence}"
      end

      def data_feed_descriptions_sentence
        data_feed_descriptions.to_sentence.downcase
      end

      def keywords
        [
          *data_feed_descriptions,
          "Activities",
          "Sports",
          "Physical Activity",
          "OpenActive"
        ]
      end

      def description
        "Near real-time availability and rich descriptions relating to the "\
              "#{data_feed_descriptions_sentence} available from "\
              "#{organisation_name}"
      end

      def data_downloads
        data_feed_types.map do |feed_type|
          OpenActive::Models::DataDownload.new(
            name: feed_type.name,
            additional_type: feed_type.same_as,
            encoding_format: "application/vnd.openactive.rpde+json; version=1",
            content_url: open_data_feed_base_url + feed_type.default_feed_path,
          )
        end
      end

      def to_dataset # rubocop:disable Metrics/MethodLength
        dataset = OpenActive::Models::Dataset.new(
          id: dataset_site_url,
          url: dataset_site_url,
          name: name,
          description: description,
          keywords: keywords,
          license: "https://creativecommons.org/licenses/by/4.0/",
          discussion_url: dataset_discussion_url,
          documentation: dataset_documentation_url,
          in_language: dataset_languages,
          schema_version: "https://www.openactive.io/modelling-opportunity-data/2.0/",
          publisher: OpenActive::Models::Organization.new(
            name: organisation_name,
            legal_name: organisation_legal_entity,
            description: organisation_plain_text_description,
            email: organisation_email,
            url: organisation_url,
            logo: OpenActive::Models::ImageObject.new(
              url: organisation_logo_url,
            ),
          ),
          date_modified: DateTime.now.new_offset(0),
          background_image: OpenActive::Models::ImageObject.new(
            url: background_image_url,
          ),
          distribution: data_downloads,
          date_published: date_first_published,
        )

        if platform_name && !platform_name.empty?
          dataset.booking_service = OpenActive::Models::BookingService.new(
            name: platform_name,
            url: platform_url,
            software_version: platform_software_version,
          )
        end

        dataset
      end
    end
  end
end

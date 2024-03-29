module OpenActive
  module DatasetSite
    class Settings
      def initialize(**params)
        super()

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
      attr_accessor :data_downloads

      # **** OPEN BOOKING ****

      attr_accessor :open_booking_api_base_url
      attr_accessor :open_booking_api_documentation_url
      attr_accessor :open_booking_api_terms_service_url
      attr_accessor :open_booking_api_registration_url
      attr_accessor :open_booking_api_authentication_authority_url

      # **** TEST SUITE CERTIFICATE ****

      attr_accessor :test_suite_certificate_url

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

      # @return [Array<String>] An array of keywords.
      def keywords
        [
          *data_feed_descriptions,
          "Activities",
          "Sports",
          "Physical Activity",
          "OpenActive"
        ]
      end

      def dataset_description
        "Near real-time availability and rich descriptions relating to the "\
              "#{data_feed_descriptions_sentence} available from "\
              "#{organisation_name}"
      end

      def webapi_description
        "API that allows for seamless booking experiences to be created for  "\
              "#{data_feed_descriptions_sentence} available from "\
              "#{organisation_name}"
      end

      # @return [OpenActive::Models::DataDownload] A DataDownload object.
      def data_download(feed_type)
        OpenActive::Models::DataDownload.new(
          name: feed_type.name,
          additional_type: feed_type.same_as,
          encoding_format: OpenActive::DatasetSite::Meta::RPDE_MEDIA_TYPE,
          content_url: open_data_feed_base_url + feed_type.default_feed_path,
        )
      end

      # @return [Array<OpenActive::Models::DataDownload>] An array of DataDownload objects.
      def data_downloads
        @data_downloads || data_feed_types.map { |feed_type| data_download(feed_type) }
      end

      # @return [OpenActive::Models::BookingService, nil]
      def booking_service
        return unless (platform_name && !platform_name.empty?) || (test_suite_certificate_url && !test_suite_certificate_url.empty?)

        booking_service = OpenActive::Models::BookingService.new()

        if (platform_name_val = platform_name)
          booking_service.name = platform_name_val
        end

        if (platform_url_val = platform_url)
          booking_service.url = platform_url_val
        end

        if (platform_software_version_val = platform_software_version)
          booking_service.software_version = platform_software_version_val
        end

        if (has_credential_val = test_suite_certificate_url)
          booking_service.has_credential = has_credential_val
        end

        booking_service
      end

      def access_service
        return unless open_booking_api_base_url && !open_booking_api_base_url.empty?
        
        access_service = OpenActive::Models::WebAPI.new(
          name: 'Open Booking API',
          description: webapi_description,
          documentation: "https://permalink.openactive.io/dataset-site/open-booking-api-documentation",
          endpoint_url: open_booking_api_base_url,
          conforms_to: ["https://openactive.io/open-booking-api/EditorsDraft/"],
          endpoint_description: "https://www.openactive.io/open-booking-api/EditorsDraft/swagger.json",
          landing_page: open_booking_api_registration_url
        )

        if (open_booking_api_documentation_url_val = open_booking_api_documentation_url)
          access_service.documentation = open_booking_api_documentation_url_val
        end

        if (open_booking_api_authentication_authority_url_val = open_booking_api_authentication_authority_url)
          access_service.authentication_authority = open_booking_api_authentication_authority_url_val
        end

        if (open_booking_api_terms_service_url_val = open_booking_api_terms_service_url)
          access_service.terms_of_service = open_booking_api_terms_service_url_val
        end

        access_service
      end

      def to_dataset # rubocop:disable Metrics/MethodLength
        dataset = OpenActive::Models::Dataset.new(
          id: dataset_site_url,
          url: dataset_site_url,
          name: name,
          description: dataset_description,
          keywords: keywords,
          license: "https://creativecommons.org/licenses/by/4.0/",
          discussion_url: dataset_discussion_url,
          documentation: "https://permalink.openactive.io/dataset-site/open-data-documentation",
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

        if (dataset_documentation_url_val = dataset_documentation_url)
          dataset.documentation = dataset_documentation_url_val
        end

        if (booking_service_val = booking_service)
          dataset.booking_service = booking_service_val
        end

        if (access_service_val = access_service)
          dataset.access_service = access_service_val
        end

        dataset
      end
    end
  end
end

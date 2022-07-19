# dataset-site-template-ruby
Ruby classes and resources supporting dataset site creation

Tools intended to simplify creation of dataset sites using templates.

For comparison, see the [.NET](https://github.com/openactive/dataset-site-template-example-dotnet) and [PHP](https://github.com/openactive/dataset-site-template-php) implementations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'openactive-dataset_site'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install openactive-dataset_site
    

## Usage

If you are developing this package, go to the [Contribution](#contribution) section.

Wherever you want to render your Dataset page, include the following instructions:
```ruby

# Render compiled template with data
renderer = OpenActive::DatasetSite::TemplateRenderer.new(settings)
puts renderer.render
```

Or to render a [CSP-compatible template](https://developer.openactive.io/publishing-data/dataset-sites#template-hosting-options), first ensure that you are serving the [CSP compatible static assets](/lib/openactive/dataset_site/datasetsite-csp.static.zip) from this version of the Ruby gem at a URL, and then including the following:
```ruby

# Render compiled CSP-compatible template with data
renderer = OpenActive::DatasetSite::TemplateRenderer.new(settings, "./path/to/styles")
puts renderer.render
```

Where `settings` could be defined like the following (as an example):
```ruby
settings = OpenActive::DatasetSite::Settings.new(
    open_data_feed_base_url: "https://customer.example.com/feed/",
    dataset_site_url: "https://halo-odi.legendonlineservices.co.uk/openactive/",
    dataset_discussion_url: "https://github.com/gll-better/opendata",
    dataset_documentation_url: "https://permalink.openactive.io/dataset-site/open-data-documentation",
    dataset_languages: ["en-GB"],
    organisation_name: "Better",
    organisation_url: "https://www.better.org.uk/",
    organisation_legal_entity: "GLL",
    organisation_plain_text_description: "Established in 1993, GLL is the largest UK-based charitable social enterprise delivering leisure, health and community services. Under the consumer facing brand Better, we operate 258 public Sports and Leisure facilities, 88 libraries, 10 children’s centres and 5 adventure playgrounds in partnership with 50 local councils, public agencies and sporting organisations. Better leisure facilities enjoy 46 million visitors a year and have more than 650,000 members.",
    organisation_logo_url: "http://data.better.org.uk/images/logo.png",
    organisation_email: "info@better.org.uk",
    platform_name: "AcmeBooker",
    platform_url: "https://acmebooker.example.com/",
    platform_software_version: "2.0",
    background_image_url: "https://data.better.org.uk/images/bg.jpg",
    date_first_published: "2019-10-28",
    open_booking_api_base_url: "https://reference-implementation.openactive.io/api/openbooking",
    open_booking_api_authentication_authority_url: "https://auth.reference-implementation.openactive.io",
    open_booking_api_documentation_url: "https://permalink.openactive.io/dataset-site/open-booking-api-documentation",
    open_booking_api_terms_service_url: "https://example.com/api-terms-page",
    open_booking_api_registration_url: "https://example.com/api-landing-page",
    test_suite_certificate_url: "https://certificates.reference-implementation.openactive.io/examples/all-features/controlled/",
    data_feed_types: [
      OpenActive::DatasetSite::FeedType::FACILITY_USE,
      OpenActive::DatasetSite::FeedType::SCHEDULED_SESSION,
      OpenActive::DatasetSite::FeedType::SESSION_SERIES,
      OpenActive::DatasetSite::FeedType::SLOT,
    ],
)
```


### Feed-level customisation
If you need to do feed specific overrides, then you may do this by overriding the method.
```ruby
settings = Class.new(OpenActive::DatasetSite::Settings) do
  def data_download(feed_type)
    val = super(feed_type)

    case feed_type
    when OpenActive::DatasetSite::FeedType::SESSION_SERIES
      val.content_url = open_data_feed_base_url + "session_series"
    end

    val
  end
end.new(
  data_feed_types: [
    OpenActive::DatasetSite::FeedType::FACILITY_USE,
    OpenActive::DatasetSite::FeedType::SCHEDULED_SESSION,
    OpenActive::DatasetSite::FeedType::SESSION_SERIES,
    OpenActive::DatasetSite::FeedType::SLOT,
  ],
  # rest of your settings here.
)
```

To match the PHP/.NET usage, you may alternatively use this approach, however it's less advised as there are more details to get right (and it risks a mismatch between the downloads and the advertised feed types):
```ruby
settings = OpenActive::DatasetSite::Settings.new(
    # your settings here,
    data_feed_types: [
      OpenActive::DatasetSite::FeedType::SESSION_SERIES,
    ],
    data_downloads: [
        OpenActive::Models::DataDownload.new(
          name: "SessionSeries",
          additional_type: "https://openactive.io/SessionSeries",
          encoding_format:  OpenActive::DatasetSite::Meta.RPDE_MEDIA_TYPE,
          content_url: open_data_feed_base_url + "session-series",
        )
    ]
)
```

### Dataset
```ruby
dataset = OpenActive::Models::Dataset.new(
  id: "http://example.com/dataset/",
  url: "http://example.com/dataset/",
  description:
    "Near real-time availability and rich descriptions relating to the facilities and sessions available from Simpleweb",
  access_service:
    OpenActive::Models::WebAPI.new(
      name: 'Open Booking API',
      description: "API that allows for seamless booking experiences to be created for facilities and sessions available from Simpleweb",
      documentation: "https://permalink.openactive.io/dataset-site/open-booking-api-documentation",
      terms_of_service: "https://example.com/api-terms-page",
      endpoint_url: "https://reference-implementation.openactive.io/api/openbooking",
      authentication_authority: "https://auth.reference-implementation.openactive.io",
      conforms_to: ["https://openactive.io/open-booking-api/EditorsDraft/"],
      endpoint_description: "https://www.openactive.io/open-booking-api/EditorsDraft/swagger.json",
      landing_page: "https://example.com/api-landing-page"
    ),
  dateModified: "2019-12-09T15:36:15+00:00",
  keywords:
    ["Facilities",
     "Sessions",
     "Activities",
     "Sports",
     "Physical Activity",
     "OpenActive"],
  schemaVersion: "https://www.openactive.io/modelling-opportunity-data/2.0/",
  license: "https://creativecommons.org/licenses/by/4.0/",
  publisher:
    OpenActive::Models::Organization.new(
      name: "Simpleweb",
      description:
       "Simpleweb is a purpose driven software company that specialises in new technologies, product development, and human interaction.",
      url: "https://www.simpleweb.co.uk/",
      legalName: "Simpleweb Ltd",
      logo:
       OpenActive::Models::ImageObject.new(
         url:
           "https://simpleweb.co.uk/wp-content/uploads/2015/07/facebook-default.png",
       ),
      email: "spam@simpleweb.co.uk",
    ),
  discussionUrl: "https://github.com/simpleweb/sw-oa-php-test-site",
  datePublished: "2019-11-05T00:00:00+00:00",
  inLanguage: ["en-GB"],
  distribution:
    [OpenActive::Models::DataDownload.new(
      name: "FacilityUse",
      additionalType: "https://openactive.io/FacilityUse",
      encodingFormat: "application/vnd.openactive.rpde+json; version=1",
      contentUrl: "http://example.com/feed/facility-uses",
    ),
     OpenActive::Models::DataDownload.new(
       name: "ScheduledSession",
       additionalType: "https://openactive.io/ScheduledSession",
       encodingFormat: "application/vnd.openactive.rpde+json; version=1",
       contentUrl: "http://example.com/feed/scheduled-sessions",
     ),
     OpenActive::Models::DataDownload.new(
       name: "SessionSeries",
       additionalType: "https://openactive.io/SessionSeries",
       encodingFormat: "application/vnd.openactive.rpde+json; version=1",
       contentUrl: "http://example.com/feed/session_series",
     ),
     OpenActive::Models::DataDownload.new(
       name: "Slot",
       additionalType: "https://openactive.io/Slot",
       encodingFormat: "application/vnd.openactive.rpde+json; version=1",
       contentUrl: "http://example.com/feed/slots",
     )],
  backgroundImage:
    OpenActive::Models::ImageObject.new(
      url:
        "https://simpleweb.co.uk/wp-content/uploads/2017/06/IMG_8994-500x500-c-default.jpg",
    ),
  documentation: "https://permalink.openactive.io/dataset-site/open-data-documentation",
  name: "Simpleweb Facilities and Sessions",
  booking_service:
    OpenActive::Models::BookingService.new(
      name: "SimpleWeb Booking",
      url: "https://www.example.com/",
      has_credential: "https://certificates.reference-implementation.openactive.io/examples/all-features/controlled/",
    )
)

renderer = OpenActive::DatasetSite::TemplateRenderer.new(dataset)

puts renderer.render
```

### Dataset patching
The dataset generation should already be good for most purposes, if needing to change just a couple of fields then
you may be better of patching just those fields.
```ruby
settings = OpenActive::DatasetSite::Settings.new(
  # your settings here
)

dataset = settings.to_dataset

dataset.description = "Some better non-generated description here."

renderer = OpenActive::DatasetSite::TemplateRenderer.new(dataset)

puts renderer.render
```

### API

#### OpenActive::DatasetSite::Settings
Accepts a config hash containing the following keys:

##### Settings

| Key                                             | Type        | Description |
| ----------------------------------------------- | ----------- | ----------- |
| `open_data_feed_base_url`                       | `string`    | The the base URL for the open data feeds |
| `dataset_site_url`                              | `string`    | The URL where this dataset site is displayed (the page's own URL) |
| `dataset_discussion_url`                        | `string`    | The GitHub issues page for the dataset |
| `dataset_documentation_url`                     | `string`    | Any documentation specific to the dataset. Defaults to https://permalink.openactive.io/dataset-site/open-data-documentation if not provided, which should be used if no documentation is available. |
| `dataset_languages`                             | `string[]`  | The languages available in the dataset, following the IETF BCP 47 standard. Defaults to `array("en-GB")`. |
| `organisation_name`                             | `string`    | The publishing organisation's name |
| `organisation_url`                              | `string`    | The publishing organisation's URL |
| `organisation_legal_entity`                     | `string`    | The legal name of the publishing organisation of this dataset |
| `organisation_plain_text_description`           | `string`    | A plain text description of this organisation |
| `organisation_logo_url`                         | `string`    | An image URL of the publishing organisation's logo, ideally in PNG format |
| `organisation_email`                            | `string`    | The contact email of the publishing organisation of this dataset |
| `platform_name`                                 | `string`    | The software platform's name. Only set this if different from the publishing organisation, otherwise leave as null to exclude platform metadata. |
| `platform_url`                                  | `string`    | The software platform's website |
| `platform_software_version`                     | `string`    | The software platform's software version |
| `background_image_url`                          | `string`    | The background image to show on the Dataset Site page |
| `date_first_published`                          | `string`    | The date the dataset was first published |
| `open_booking_api_base_url`                     | `string`    | The Base URI of this implementation of the Open Booking API |
| `open_booking_api_authentication_authority_url` | `string`    | The location of the OpenID Provider that must be used to access the API |
| `open_booking_api_documentation_url`            | `string`    | The URL of documentation related to how to use the Open Booking API. Defaults to https://permalink.openactive.io/dataset-site/open-booking-api-documentation if not provided, which should be used if no system-specific documentation is available. |
| `open_booking_api_terms_service_url`            | `string`    | The URL of terms of service related to the use of this API |
| `open_booking_api_registration_url`             | `string`    | The URL of a web page that the Broker may use to obtain access to the API, e.g. via a web form |
| `test_suite_certificate_url`                    | `string`    | The URL of the OpenActive Test Suite certificate for this booking system |
| `data_feed_types`                               | `FeedType[]`| A list of supported DataFeed types |

And `data_feed_types` must be an array of `FeedType` constants, which auto-generates the metadata associated which each feed using best-practice values. See [available types](#feedtype)

#### OpenActive::DatasetSite::TemplateRenderer.new(settings, static_assets_path_url = nil)

Accepts a [`settings`](#settings) or [`DataSet`](#dataset) object. This is a Mustache engine.

If `static_assets_path_url` is provided, the [CSP-compatible template](https://developer.openactive.io/publishing-data/dataset-sites#template-hosting-options) is rendered. In this case you must ensure that you are serving the contents of the [CSP compatible static assets archive](/lib/openactive/dataset_site/datasetsite-csp.static.zip) at this location, using the assets archive in this version of the Ruby gem.

##### .render

Returns a string corresponding to the compiled HTML, based on the `datasetsite.mustache`, and the provided [`settings`](#settings) or [`DataSet`](#dataset) object

#### `FeedType`

A class containing the supported distribution types:

| Constant                  | Name                    |
| ------------------------- | ----------------------- |
| `COURSE`                  | `Course`                |
| `COURSE_INSTANCE`         | `CourseInstance`        |
| `EVENT`                   | `Event`                 |
| `EVENT_SERIES`            | `EventSeries`           |
| `FACILITY_USE`            | `FacilityUse`           |
| `HEADLINE_EVENT`          | `HeadlineEvent`         |
| `INDIVIDUAL_FACILITY_USE` | `IndividualFacilityUse` |
| `SCHEDULED_SESSION`       | `ScheduledSession`      |
| `SESSION_SERIES`          | `SessionSeries`         |
| `SLOT`                    | `Slot`                  |

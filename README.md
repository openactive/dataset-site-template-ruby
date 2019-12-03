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

Where `settings` could be defined like the following (as an example):
```ruby
settings = OpenActive::DatasetSite::Settings.new(
    open_data_feed_base_url: "https://customer.example.com/feed/",
    dataset_site_url: "https://halo-odi.legendonlineservices.co.uk/openactive/",
    dataset_discussion_url: "https://github.com/gll-better/opendata",
    dataset_documentation_url: "https://docs.acmebooker.example.com/",
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
    data_feed_types: [
      OpenActive::DatasetSite::FeedType::FACILITY_USE,
      OpenActive::DatasetSite::FeedType::SCHEDULED_SESSION,
      OpenActive::DatasetSite::FeedType::SESSION_SERIES,
      OpenActive::DatasetSite::FeedType::SLOT,
    ],
)
```

### API

#### OpenActive::DatasetSite::Settings
Accepts a config hash containing the following keys:

##### Settings

| Key                                     | Type        | Description |
| --------------------------------------- | ----------- | ----------- |
| `open_data_feed_base_url`               | `string`    | The the base URL for the open data feeds |
| `dataset_site_url`                      | `string`    | The URL where this dataset site is displayed (the page's own URL) |
| `dataset_discussion_url`                | `string`    | The GitHub issues page for the dataset |
| `dataset_documentation_url`             | `string`    | Any documentation specific to the dataset. Defaults to https://developer.openactive.io/ if not provided, which should be used if no documentation is available. |
| `dataset_languages`                     | `string[]`  | The languages available in the dataset, following the IETF BCP 47 standard. Defaults to `array("en-GB")`. |
| `organisation_name`                     | `string`    | The publishing organisation's name |
| `organisation_url`                      | `string`    | The publishing organisation's URL |
| `organisation_legal_entity`             | `string`    | The legal name of the publishing organisation of this dataset |
| `organisation_plain_text_description`   | `string`    | A plain text description of this organisation |
| `organisation_logo_url`                 | `string`    | An image URL of the publishing organisation's logo, ideally in PNG format |
| `organisation_email`                    | `string`    | The contact email of the publishing organisation of this dataset |
| `platform_name`                         | `string`    | The software platform's name. Only set this if different from the publishing organisation, otherwise leave as null to exclude platform metadata. |
| `platform_url`                          | `string`    | The software platform's website |
| `platform_software_version`             | `string`    | The software platform's software version |
| `background_image_url`                  | `string`    | The background image to show on the Dataset Site page |
| `date_first_published`                  | `string`    | The date the dataset was first published |
| `data_feed_types`                       | `FeedType[]`| A list of supported DataFeed types |

And `data_feed_types` must be an array of `FeedType` constants, which auto-generates the metadata associated which each feed using best-practice values. See [available types](#feedtype)

#### OpenActive::DatasetSite::TemplateRenderer.new(settings)

Accepts a settings or a DataSet object. This is a Mustache engine.

##### .render

Returns a string corresponding to the compiled HTML, based on the `datasetsite.mustache`, the provided [`settings`](#settings)

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

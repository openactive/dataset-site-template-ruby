require 'rubygems'
require 'bundler/setup'

require "openactive/dataset_site"

dataset = OpenActive::Models::Dataset.new(
  id: "http://example.com/dataset/",
  url: "http://example.com/dataset/",
  description:
    "Near real-time availability and rich descriptions relating to the facilities and sessions available from Simpleweb",
  date_modified: "2019-12-09T15:36:15+00:00",
  keywords:
    ["Facilities",
     "Sessions",
     "Activities",
     "Sports",
     "Physical Activity",
     "OpenActive"],
  schema_version: "https://www.openactive.io/modelling-opportunity-data/2.0/",
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
  discussion_url: "https://github.com/simpleweb/sw-oa-php-test-site",
  date_published: "2019-11-05T00:00:00+00:00",
  in_language: ["en-GB"],
  distribution:
    [OpenActive::Models::DataDownload.new(
      name: "FacilityUse",
      additional_type: "https://openactive.io/FacilityUse",
      encoding_format: "application/vnd.openactive.rpde+json; version=1",
      content_url: "http://example.com/feed/facility-uses",
    ),
     OpenActive::Models::DataDownload.new(
       name: "ScheduledSession",
       additional_type: "https://openactive.io/ScheduledSession",
       encoding_format: "application/vnd.openactive.rpde+json; version=1",
       content_url: "http://example.com/feed/scheduled-sessions",
     ),
     OpenActive::Models::DataDownload.new(
       name: "SessionSeries",
       additional_type: "https://openactive.io/SessionSeries",
       encoding_format: "application/vnd.openactive.rpde+json; version=1",
       content_url: "http://example.com/feed/session_series",
     ),
     OpenActive::Models::DataDownload.new(
       name: "Slot",
       additional_type: "https://openactive.io/Slot",
       encoding_format: "application/vnd.openactive.rpde+json; version=1",
       content_url: "http://example.com/feed/slots",
     )],
  background_image:
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
    ),
)

renderer = OpenActive::DatasetSite::TemplateRenderer.new(dataset)

puts renderer.render

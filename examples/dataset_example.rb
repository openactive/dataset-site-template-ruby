require 'rubygems'
require 'bundler/setup'

require "openactive/dataset_site"

dataset = OpenActive::Models::Dataset.new(
  id: "http://example.com/dataset/",
  description:
    "Near real-time availability and rich descriptions relating to the facilities and sessions available from Simpleweb",
  url: "http://example.com/dataset/",
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
  documentation: "https://developer.openactive.io/",
  name: "Simpleweb Facilities and Sessions",
)

renderer = OpenActive::DatasetSite::TemplateRenderer.new(dataset)

puts renderer.render

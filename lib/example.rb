require 'rubygems'
require 'bundler/setup'

require "openactive/dataset"

settings = {
  open_data_feed_base_url: "http://example.com/feed/",
  dataset_site_url: "http://example.com/dataset/",
  dataset_discussion_url: "https://github.com/simpleweb/sw-oa-php-test-site",
  dataset_documentation_url: "https://developer.openactive.io/",
  dataset_languages: ["en-GB"],
  organisation_name: "Simpleweb",
  organisation_url: "https://www.simpleweb.co.uk/",
  organisation_legal_entity: "Simpleweb Ltd",
  organisation_plain_text_description: "Simpleweb is a purpose driven software company that specialises in new "\
                                       "technologies, product development, and human interaction.",
  organisation_logo_url: "https://simpleweb.co.uk/wp-content/uploads/2015/07/facebook-default.png",
  organisation_email: "spam@simpleweb.co.uk",
  background_image_url: "https://simpleweb.co.uk/wp-content/uploads/2017/06/IMG_8994-500x500-c-default.jpg",
  date_first_published: "2019-11-05", # remember, remember the fifth of November...
}

feed_types = [
  OpenActive::Dataset::FeedType::FACILITY_USE,
  OpenActive::Dataset::FeedType::SCHEDULED_SESSION,
  OpenActive::Dataset::FeedType::SESSION_SERIES,
  OpenActive::Dataset::FeedType::SLOT,
]

oa_settings = OpenActive::Dataset::Settings.new(
  **settings,
  data_feed_types: feed_types,
)

renderer = OpenActive::Dataset::TemplateRenderer.new(oa_settings)

puts renderer.render

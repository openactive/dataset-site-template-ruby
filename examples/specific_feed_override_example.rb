require 'rubygems'
require 'bundler/setup'

require "openactive/dataset_site"

feed_types = [
  OpenActive::DatasetSite::FeedType::FACILITY_USE,
  OpenActive::DatasetSite::FeedType::SCHEDULED_SESSION,
  OpenActive::DatasetSite::FeedType::SESSION_SERIES,
  OpenActive::DatasetSite::FeedType::SLOT,
]

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
  open_data_feed_base_url: "http://example.com/feed/",
  dataset_site_url: "http://example.com/dataset/",
  dataset_discussion_url: "https://github.com/simpleweb/sw-oa-php-test-site",
  dataset_documentation_url: "https://permalink.openactive.io/dataset-site/open-data-documentation",
  dataset_languages: ["en-GB"],
  organisation_name: "Simpleweb",
  organisation_url: "https://www.simpleweb.co.uk/",
  organisation_legal_entity: "Simpleweb Ltd",
  organisation_plain_text_description: "Simpleweb is a purpose driven software company that specialises in new "\
                                       "technologies, product development, and human interaction.",
  organisation_logo_url: "https://simpleweb.co.uk/wp-content/uploads/2015/07/facebook-default.png",
  organisation_email: "spam@simpleweb.co.uk",
  background_image_url: "https://simpleweb.co.uk/wp-content/uploads/2017/06/IMG_8994-500x500-c-default.jpg",
  date_first_published: "2019-11-05",
  data_feed_types: feed_types,
)

renderer = OpenActive::DatasetSite::TemplateRenderer.new(settings)

puts renderer.render

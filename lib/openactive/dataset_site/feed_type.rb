module OpenActive
  module DatasetSite
    class FeedType < TypesafeEnum::Base
      new :COURSE, "Course" do
        @name = "Course"
        @same_as = "https://openactive.io/Course"
        @default_feed_path = "courses"
        @possible_kinds = ["Course"]
        @display_name = "Courses"
      end
      new :COURSE_INSTANCE, "CourseInstance" do
        @name = "CourseInstance"
        @same_as = "https://openactive.io/CourseInstance"
        @default_feed_path = "course-instances"
        @possible_kinds = ["CourseInstance", "CourseInstance.Event"]
        @display_name = "Courses"
      end
      new :EVENT, "Event" do
        @name = "Event"
        @same_as = "https://schema.org/Event"
        @possible_kinds = ["Event"]
        @display_name = "Events"
      end
      new :EVENT_SERIES, "EventSeries" do
        @name = "EventSeries"
        @same_as = "https://schema.org/EventSeries"
        @default_feed_path = "event-series"
        @possible_kinds = ["EventSeries"]
        @display_name = "undefined"
      end
      new :FACILITY_USE, "FacilityUse" do
        @name = "FacilityUse"
        @same_as = "https://openactive.io/FacilityUse"
        @default_feed_path = "facility-uses"
        @possible_kinds = ["FacilityUse"]
        @display_name = "Facilities"
      end
      new :HEADLINE_EVENT, "HeadlineEvent" do
        @name = "HeadlineEvent"
        @same_as = "https://openactive.io/HeadlineEvent"
        @default_feed_path = "headline-events"
        @possible_kinds = ["HeadlineEvent"]
        @display_name = "Events"
      end
      new :INDIVIDUAL_FACILITY_USE, "IndividualFacilityUse" do
        @name = "IndividualFacilityUse"
        @same_as = "https://openactive.io/IndividualFacilityUse"
        @default_feed_path = "individual-facility-uses"
        @possible_kinds = ["IndividualFacilityUse"]
        @display_name = "Facilities"
      end

      new :SCHEDULED_SESSION, "ScheduledSession" do
        @name = "ScheduledSession"
        @same_as = "https://openactive.io/ScheduledSession"
        @default_feed_path = "scheduled-sessions"
        @possible_kinds = ["ScheduledSession", "ScheduledSession.SessionSeries"]
        @display_name = "Sessions"
      end
      new :SESSION_SERIES, "SessionSeries" do
        @name = "SessionSeries"
        @same_as = "https://openactive.io/SessionSeries"
        @default_feed_path = "session-series"
        @possible_kinds = ["SessionSeries", "SessionSeries.ScheduledSession"]
        @display_name = "Sessions"
      end
      new :SLOT, "Slot" do
        @name = "Slot"
        @same_as = "https://openactive.io/Slot"
        @default_feed_path = "slots"
        @possible_kinds = ["FacilityUse/Slot", "IndividualFacilityUse/Slot"]
        @display_name = "Facilities"
      end

      # @return [String]
      attr_reader :name

      # @return [String]
      attr_reader :same_as

      # @return [String]
      attr_reader :default_feed_path

      # @return [Array<String>]
      attr_reader :possible_kinds

      # @return [String]
      attr_reader :display_name
    end
  end
end

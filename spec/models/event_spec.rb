require 'rails_helper'
require "shared_upcoming_event"

RSpec.describe Event, type: :model do
  include_context "shared context for up coming events"

  it "loaded list of upcoming events successfully" do
    events = Event.upcoming_events
    expect(events).to match_array([@upcomingEvent, @upcomingEvent2])
  end

  it "search events by name" do
    events = Event.search("Upcoming")
    expect(events).to match_array(@upcomingEvent)
  end
end
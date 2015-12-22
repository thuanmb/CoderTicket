require 'rails_helper'
require "shared_upcoming_event"

RSpec.describe "routing to events", :type => :routing do
  describe "/events" do
    it "routes root to events#index" do
      expect(:get => "/").to route_to(
        :controller => "events",
        :action => "index"
      )
    end

    it "routes /events to events#index" do
      expect(:get => "/events").to route_to(
        :controller => "events",
        :action => "index"
      )
    end
  end

  describe "/events/:id" do
    include_context "shared context for up coming events"

    it "routes /events/:id to events#show" do
      expect(:get => "/events/#{@upcomingEvent.id}").to route_to(
        :controller => "events",
        :action => "show",
        :id => "#{@upcomingEvent.id}"
      )
    end
  end
end
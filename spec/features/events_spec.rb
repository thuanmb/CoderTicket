require 'rails_helper'
require "shared_upcoming_event"

RSpec.feature "Events", type: :feature do
	include_context "shared context for up coming events"

  it "go to booking page" do
  	visit "/events/#{@upcomingEvent.id}"
  	click_button "BOOK NOW"
  	expect(page).to have_content @upcomingEvent.name
	end
end

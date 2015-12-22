require "spec_helper"
require "shared_upcoming_event"

RSpec.describe "events/index", :type => :view do
  include_context "shared context for up coming events"

  it "renders _card for each event" do
    assign(:events, [
      double(Event, :name => "Upcoming event 1", :hero_image_url => "images/some_img_1.jpg", :extended_html_description => "Some description 1"),
      double(Event, :name => "Upcoming event 2", :hero_image_url => "images/some_img_2.jpg", :extended_html_description => "Some description 2")
    ])

    render

    expect(view).to render_template(:partial => "_card", :count => 2)
    expect(rendered).to include("Upcoming event 1")
    expect(rendered).to include("Upcoming event 2")

    expect(rendered).to include("Some description 1")
    expect(rendered).to include("Some description 2")
  end
end
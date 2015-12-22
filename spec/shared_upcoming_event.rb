require "spec_helper"

RSpec.shared_context "shared context for up coming events" do
	before do
    # Create Regions
    ['Ho Chi Minh', 'Ha Noi', 'Binh Thuan', 'Da Nang', 'Lam Dong'].each do |r|
      Region.create(name: r)
    end

    # Create Categories
    ['Entertainment', 'Learning', 'Everything Else'].each do |c|
      Category.create(name: c)
    end

    @user = User.create!(:name => "Admin", :email => "a@a.com", :password => "1")

    dalat = Venue.create({
      name: 'Da Lat City',
      full_address: 'Ngoc Phat Hotel 10 Hồ Tùng Mậu Phường 3, Thành phố Đà Lạt, Lâm Đồng, Thành Phố Đà Lạt, Lâm Đồng',
      region: Region.find_by(name: 'Lam Dong')
    })
    
    @upcomingEvent = Event.create!(
      :starts_at => 3.days.ago,
      :ends_at => 3.days.from_now,
      :venue => dalat,
      :extended_html_description => "A upcoming event",
      :category => Category.new,
      :name => "Upcoming event",
      :published => true
    )

    @upcomingEvent2 = Event.create!(
      :starts_at => 3.days.ago,
      :ends_at => 3.days.from_now,
      :venue => Venue.new,
      :extended_html_description => "This's new events",
      :category => Category.new,
      :name => "This's new events",
      :published => true
    )

    @pastEvent = Event.create!(
      :starts_at => 5.days.ago,
      :ends_at => 2.days.ago,
      :venue => Venue.new,
      :extended_html_description => "Past event",
      :category => Category.new,
      :name => "Past event",
      :published => true
    )

    @unpublishedEvent = Event.create!(
      :starts_at => 3.days.ago,
      :ends_at => 3.days.from_now,
      :venue => dalat,
      :extended_html_description => "An unpublished event",
      :category => Category.new,
      :name => "Unpublished event",
      :published => false
    )
  end
end
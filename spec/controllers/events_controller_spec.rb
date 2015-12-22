require "rails_helper"
require "shared_upcoming_event"

RSpec.describe EventsController, type: :controller do
  describe "GET #index" do
    include_context "shared context for up coming events"

    it "responds successfully with HTTP status code 200 for" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "render template index for" do
      get :index
      expect(response).to render_template("index")
    end

    it "load all upcoming events for" do
      get :index
      expect(assigns(:events)).to match_array([@upcomingEvent, @upcomingEvent2])
    end
  end

  describe "GET #index?search=something" do
    include_context "shared context for up coming events"
    
    it "show the search result correctly" do
      get :index, :search => 'Upcoming'

      expect(assigns(:events)).to match_array(@upcomingEvent)
    end
  end

  describe "GET #publish/:id" do
    include_context "shared context for up coming events"

    it "return error when try to publish event that don't have any ticket type" do
      # login
      session[:user_id] = @user.id
      @user.events << @unpublishedEvent

      get :publish, {:id => @unpublishedEvent.id}
      expect(flash[:error]).to eq("You don't have permission to publish this event")
    end

    it "publish event successfully" do
      # login
      session[:user_id] = @user.id
      @user.events << @unpublishedEvent
      @unpublishedEvent.ticket_types << TicketType.create!(:name => "Normal", :price => 50000, :max_quantity => 10)

      get :publish, {:id => @unpublishedEvent.id}
      
      expect(flash[:success]).to eq("Event #{@unpublishedEvent.name} published successfully")
    end
  end

  describe "GET #events/:id/edit" do
    include_context "shared context for up coming events"

    it "redirect to manage events screen if user don't have permission to edit event" do
      # login
      session[:user_id] = @user.id
      
      get :edit, {id: @upcomingEvent.id}

      expect(response).to redirect_to(manage_path)
    end

    it "show edit page when user has permission to edit event" do
      # login
      session[:user_id] = @user.id
      @user.events << @upcomingEvent
      
      get :edit, {id: @upcomingEvent.id}

      expect(response).to render_template("edit")
    end
  end
end

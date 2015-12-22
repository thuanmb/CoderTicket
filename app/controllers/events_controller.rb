class EventsController < ApplicationController
	include EventsHelper

  def index
  	if params[:search]
  		@events = Event.search(params[:search])
  	else
  		@events = Event.upcoming_events
  	end
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    require_login
    @event = Event.find(params[:id])
    if !can_edit(@event)
      redirect_to manage_path
    end
  end

  def manage_events
    require_login
    
    @events = current_user.events
  end

  def new
    @event = Event.new
  end

  def create
    params[:event][:published] = params[:event][:published] == "1"
    
    venue = Venue.new(venue_params)
    venue.region = Region.find(params[:event][:venue][:region])
    ticket_type = TicketType.new(ticket_type_params)

    @event = Event.new(event_params)
    @event.category = Category.find(category_params)
    @event.venue = venue
    @event.ticket_types << ticket_type
    current_user.events << @event

    if venue.save && ticket_type.save && @event.save && current_user.save
      flash[:success] = "Event created successfully"

      redirect_to manage_path
    else
      flash[:success] = 
        "Error while create new evenue: #{venue.errors.full_messages.join(', ')}" +
        "Error while create new ticket type: #{ticket_type.errors.full_messages.join(', ')}" +
        current_user.errors.full_messages.join(', ') +
        "Error while create new event: #{@event.errors.full_messages.join(', ')}"

      render :controller => :events, :action => :new
    end
  end

  def update
    @event = Event.find(params[:id])
    if can_edit(@event)
      params[:event][:published] = params[:event][:published] == "1"
          
      @event.venue.region = Region.find(params[:event][:venue][:region])
      @event.category = Category.find(category_params)
      
      if @event.venue.update(venue_params) && @event.update(event_params)
        flash[:success] = "Event updated successfully"

        redirect_to manage_path
      else
        flash[:success] = 
          "Error while create update evenue: #{@event.venue.errors.full_messages.join(', ')}" +
          "Error while create update event: #{@event.errors.full_messages.join(', ')}"

        render :controller => :events, :action => :edit, :id => @event.id
      end
    else
      redirect_to manage_path
    end
  end

  def publish
    require_login

    event = Event.find(params[:id])

    if can_publish(event)
      event.published = true;
      event.save

      flash[:success] = "Event #{event.name} published successfully"
    else
      flash[:error] = "You don't have permission to publish this event"
    end
    
    redirect_to manage_path
  end

  def remove_ticket_type
    @event = Event.find(params[:event_id])
    ticket_type = TicketType.find(params[:ticket_type_id])
    if ticket_type.presence
      ticket_type.destroy
      flash[:success] = "Ticket type deleted successfully"
    end
  end

  def new_ticket_type
    @event = Event.find(params[:event_id])
    ticket_type = TicketType.new(params.require(:ticket_type).permit(:name, :price, :max_quantity))
    @event.ticket_types << ticket_type

    if ticket_type.save
      flash[:success] = "Ticket type added successfully"
    else
      flash[:error] = "Error while create new ticket type: #{ticket_type.errors.full_messages.join(', ')}"
    end
  end

  private
    def event_params
      params.require(:event).permit(:name, :starts_at, :ends_at, :hero_image_url, :extended_html_description, :published)
    end

    def category_params
      params[:event][:category].to_i
    end

    def venue_params
      params[:event].require(:venue).permit(:name, :full_address)
    end

    def ticket_type_params
      params[:event].require(:ticket_type).permit(:name, :price, :max_quantity)
    end
end

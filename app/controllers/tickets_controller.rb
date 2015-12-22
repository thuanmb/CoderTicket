class TicketsController < ApplicationController
  def new
    require_login
    @event = Event.find(params[:event_id])
  end

  def create
    event = Event.find(params[:event_id])

    # do not allow user buy tickets for past event
    if event.is_past_event?
      flash[:error] = "We're sorry! This event is ended!"
      render :action => :new
    end

    booked_tickets = get_request_tickets
    valid_tickets = []

    event.ticket_types.each_with_index do |type, index|
      quantity =  booked_tickets[index].to_i
      if quantity > type.max_quantity
        flash[:alert] = "The ticket \"#{type.name}\", exceeds the max number of ticket quantity"
        render :action => :new

      elsif quantity > 0
          valid_tickets << {type: type, quantity: quantity}
      end
    end

    @success_tickets = []
    @error_tickets = []
    valid_tickets.each do |ticket|
      ticket_type = ticket[:type]
      ticket_quantity = ticket[:quantity]

      if current_user.tickets.count >= 10
        @error_tickets << get_ticket_error(ticket_type, "User cannot buy more tickets for this event")
      elsif ticket_quantity <= ticket_type.max_quantity

        newTicket = get_ticket(ticket_type, ticket_quantity)

        if newTicket.save
          ticket_type.max_quantity -= ticket_quantity
          ticket_type.save

          @success_tickets << newTicket.id
        else
          @error_tickets << get_ticket_error(ticket_type, newTicket.errors.full_messages.join(', '))
        end
      end
    end

    session[:success_tickets] = @success_tickets
    session[:error_tickets] = @error_tickets
    redirect_to "/events/#{event.id}/tickets/thank_you", success: @success_tickets, error: @error_tickets
  end

  def thank_you
    @event = Event.find(params[:event_id])
    @success_tickets = []
    @error_tickets = []
    @total = 0

    session[:success_tickets].each do |ticket_id|
      ticket = Ticket.find(ticket_id)
      @success_tickets << ticket
      @total += ticket.ticket_type.price * ticket.quantity
    end

    session[:error_tickets].each do |error|
      @error_tickets << { ticket: TicketType.find(error.ticket_id), message: error.message }
    end
  end

  private
    def get_request_tickets
      params.require(:event)[:ticket_types]
    end

    def get_ticket(type, quantity)
      ticket = Ticket.new(:quantity => quantity)
      ticket.ticket_type = type;
      ticket.user = current_user

      ticket
    end

    def get_ticket_error(type, msg)
      {ticket_id: type.id, message: msg}
    end
end

require 'rails_helper'

RSpec.describe Ticket, type: :model do
  before(:each) do
  	@ticket_type = TicketType.create(:price => 50000, :name => "Normal", :max_quantity => 10)
	end

	it "create new ticket with quantity less than max quantity" do
		ticket = Ticket.new(:quantity => 5)
		ticket.ticket_type = @ticket_type
		ticket.save

		expect(ticket.errors.messages.length).to eq 0
	end

	it "create new ticket with quantity greater than max quantity will raise error" do
		ticket = Ticket.new(:quantity => @ticket_type.max_quantity + 1)
		ticket.ticket_type = @ticket_type
		
		expect { ticket.save }.to raise_error("Quantity exceeds the max quantity (#{ticket.quantity} > #{@ticket_type.max_quantity})")
	end
end

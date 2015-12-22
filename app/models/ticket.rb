class Ticket < ActiveRecord::Base
  belongs_to :ticket_type
  belongs_to :user

  before_save :validate_number_of_ticket

  private
    def validate_number_of_ticket
      raise "Quantity exceeds the max quantity (#{self.quantity} > #{self.ticket_type.max_quantity})" if self.quantity > self.ticket_type.max_quantity
    end
end

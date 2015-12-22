module TicketsHelper
	def format_price(price)
    helper.number_to_currency(price, precision: 0, unit: "VNĐ", format: "%n %u")
  end

  private
  	def helper
        @helper ||= Class.new do
        include ActionView::Helpers::NumberHelper
    end.new
  end
end

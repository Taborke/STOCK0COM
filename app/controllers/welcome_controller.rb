class WelcomeController < ApplicationController

	def index
		
		t = Time.now #this will tell you if the NYSE is still currently open
		if (t.hour > 21 || (t.hour < 14 && t.min >= 30)) || (t.wday == 0) || (t.wday == 6)
			@market_closed = "Closed"	
		else
			@market_closed = "Open"
		end
		@stocks = []
		#this puts each stock in an array to display on the front page of the site
        Stock.all.each do |stock|
        last_stock = StockHistory.where(stock: stock).asc(:trade_date).last
        unless last_stock.nil?
          @stocks.push(last_stock)
        end
      end
	end
end

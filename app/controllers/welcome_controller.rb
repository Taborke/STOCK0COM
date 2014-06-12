class WelcomeController < ApplicationController

	def index
      @stocks = []
      Stock.all.each do |stock|

        last_stock = StockHistory.where(stock: stock).asc(:trade_date).last
        unless last_stock.nil?
          @stocks.push(last_stock)
        end
      end
	end
end

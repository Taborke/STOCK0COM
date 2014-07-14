class StocksController < ApplicationController
 	
 	def show
 	#this shows the list of stock histories given a stock id
    @stocksymbol = Stock.find(params[:id])
    @displays = StockHistory.where(stock: @stocksymbol).desc(:trade_date)
  	end
  
end

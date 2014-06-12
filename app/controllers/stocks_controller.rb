class StocksController < ApplicationController
 	
 	def show
    @stocksymbol = Stock.find(params[:id])
    @displays = StockHistory.where(stock: @stocksymbol).desc(:trade_date)
  	end
  
end

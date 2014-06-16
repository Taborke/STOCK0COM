require 'open-uri'
task :load_stock_history => :environment  do
	StockHistory.all.destroy_all
	Stock.all.destroy_all
	stock_index_symbols = ["%5EIXIC", "%5EGSPC", "DIA", "%5ENDX"]
	stock_names = ["NASDAQ", "S&P", "DOW", "NAS100"]
	stock_index_symbols.each_with_index do |symbol, index|
		print "\n loading #{symbol}" 
		stock = Stock.find_or_create_by(symbol: symbol, name: stock_names[index])
		stock.get_historical_data(100)
	end
end


task :get_todays_quote => :environment do
    stock_index_symbols = ["%5EIXIC", "%5EGSPC", "DIA"]
    stock_names = ["NASDAQ", "S&P", "DOW"]
    @todays_quote = YahooFinance.quotes(stock_index_symbols, [:volume, :close, :previous_close, :last_trade_date, :change_in_percent])
    stock_index_symbols.each_with_index do |symbol, index|
        print "\n loading #{symbol} \n"
        print @todays_quote[index].volume
        print " volume \n"
        print @todays_quote[index].close
        print " close \n"
        print @todays_quote[index].previous_close
        print " prev close \n" 
        print @todays_quote[index].last_trade_date
        print "last date \n"
        stock = Stock.where(symbol: symbol, name: stock_names[index]).first
        stock.quote_today(@todays_quote, index)
    end
end

task :distribution_day_notification => :environment do
   Stock.each do |stocky|
        @stocksymbol = stocky
        @current_day = StockHistory.where(stock: @stocksymbol).last
        #since I'll call the get_todays_quote task before this one the lastest stock entered should be todays
        if (@current_day.dist_day) then
            @weeks_ago = Time.now - (6*7*24*60*60) #6 weeks ago
            @past_dist_days = StockHistory.where(stock: @stocksymbol, dist_day: true, :trade_date.gte => @weeks_ago)
            @past_dist_days.each do |day|
                print day.trade_date.strftime("%m/%d/%Y")
            end
            UserMailer.dist_day_email(@past_dist_days).deliver
        end
   end
end
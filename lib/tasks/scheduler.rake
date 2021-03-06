require 'open-uri'
task :load_stock_history => :environment  do
	StockHistory.all.destroy_all
	Stock.all.destroy_all
	stock_index_symbols = ["%5EIXIC", "%5EGSPC", "DIA"]
	stock_names = ["NASDAQ", "S&P", "DOW"]
	stock_index_symbols.each_with_index do |symbol, index|
		print "\n loading #{symbol}" 
		stock = Stock.find_or_create_by(symbol: symbol, name: stock_names[index])
		stock.get_historical_data(200)
	end
end


task :get_todays_quote => :environment do

    Stock.each do |stock|
        print "\n loading #{stock.name}" 
        stock.get_historical_data(3)
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

task :test_welcome => :environment do
    @user = User.all.sample
    UserMailer.welcome_email(@user).deliver
end
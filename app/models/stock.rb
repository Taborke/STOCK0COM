class Stock
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :stock_histories

  field :symbol,         type: String
  field :name,           type: String

  scope :trade_date_desc, -> { order_by(trade_date: :desc) }

  validates :symbol, presence: true

  def get_historical_data(days) 
    back_date = Time.now - (24*60*60*days)
    stock_histories = YahooFinance.historical_quotes(self.symbol, back_date, Time::now, {raw: false}).reverse
    stock_histories.each_with_index do |quote, index|
        stock_history = StockHistory.find_or_create_by(stock: self, trade_date: quote.trade_date)
        percent_change = Stock.calculate_percent_change(quote, stock_histories[(index - 1)])
        volume_change = Stock.calculate_volume_change(quote, stock_histories[(index - 1)])
        previous_close = stock_histories[(index - 1)].close
        print "\n #{percent_change}"
        print "#{quote}"
        stock_history.update_attributes(
            volume: quote.volume, 
            close: quote.close, 
            percent_change: percent_change,
            previous_close: previous_close,
            volume_change: volume_change,
            dist_day: Stock.distribution_day?(percent_change, volume_change))
        end
  end

  def quote_today(todays_quote, index)
    @todays_quote = todays_quote
    yesterday = Stock.previous_stock
    today = StockHistory.find_or_create_by(stock: self, trade_date: @todays_quote[index].trade_date, volume: @todays_quote[index].volume)
    
    print today.trade_date
    
    percent_change = Stock.calculate_percent_change(today, yesterday)
    volume_change = Stock.calculate_volume_change(today, yesterday)
    previous_close = yesterday.close
    @today.update_attributes(
        volume: today.volume, 
        close: today.close, 
        percent_change: percent_change,
        previous_close: previous_close,
        volume_change: volume_change,
        dist_day: Stock.distribution_day?(percent_change, volume_change))
  end

  def previous_stock
    @previous_stock ||= StockHistory.where(stock: self).desc(:trade_date).first
  end

  def self.calculate_percent_change(quote, previous_quote)
      ((quote.close - previous_quote.close)/quote.close) * 100
  end

  def self.calculate_volume_change(quote, previous_quote)
      quote.volume - previous_quote.volume
  end

  def self.distribution_day?(percent_change, volume_change)
     !!((percent_change < -0.3) && (volume_change > 0))
  end
  
end

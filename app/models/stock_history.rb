class StockHistory
  include Mongoid::Document
    belongs_to :stock

	field :close,          type: Float
	field :previous_close, type: Float
	field :percent_change, type: Float
	field :dist_day,       type: Boolean
	field :volume,         type: Float
	field :volume_change,  type: Float
	field :trade_date,     type: DateTime

	#may add follow through day boolean and last_dday_date
end

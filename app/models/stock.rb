class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.lookup(ticker_symbol)
    company = Alphavantage::Fundamental.new(symbol: ticker_symbol)
    price_quote = Alphavantage::TimeSeries.new(symbol: ticker_symbol).quote

    if !company || company.overview.name == nil
      # byebug
      return nil
    end

    begin
      new(ticker: ticker_symbol, name: company.overview.name, last_price: price_quote.price)
    rescue => exception
      # byebug
      return nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def self.new_lookup (ticker_symbol)
    count = 5
    stock = lookup(ticker_symbol)
    # byebug
    loop do
      break if (stock != nil && !stock.ticker.blank? && !stock.name.blank?) || count == 0
      # byebug
      count -= 1
      stock = lookup(ticker_symbol)
    end

    return stock
  end

end

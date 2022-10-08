class Stock < ApplicationRecord

  def self.new_lookup(ticker_symbol)
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

end

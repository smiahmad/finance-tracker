class UserStocksController < ApplicationController
  def create
    stock = Stock.check_db(params[:ticker])
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      # stock.save
      save_stock(stock)
    end
    if stock == nil || stock.name == nil
      flash[:notice] = "Server is slow. Stock not added!"
      redirect_to my_portfolio_path
     else
      @user_stock = UserStock.create(user: current_user, stock: stock)
      flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
      redirect_to my_portfolio_path
     end
  end

  def save_stock(stock)
    attempts = 0
    while attempts < 5
      begin
        stock.save
        break
      rescue => exception
        attempts += 1
      end
    end
  end

  def destroy
    stock = Stock.find(params[:id])
    user_stock=UserStock.where(stock_id: stock.id, user_id: current_user.id).first
    user_stock.destroy
    flash[:notice] = "#{stock.ticker} was successfully removed from your portfolio"
    redirect_to my_portfolio_path
  end

end

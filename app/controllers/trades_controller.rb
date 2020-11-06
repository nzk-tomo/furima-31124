class TradesController < ApplicationController
  def index
    @item = Item.find(params[:item_id])
  end

  def create
    @item_trade = ItemTrade.new(trade_params) 

    if @item_trade.save
      redirect_to root_path
    else
      render :index
    end
  end

  private

  def trade_params
    params.permit(:postal_code, :prefecture_id, :city, :address, :building, :phone_number, :user_id, :item_id).merge(user_id: current_user.id)
  end

  # def address_params(trade)
  #   params.permit(:postal_code, :prefecture, :city, :house_number, :building_name).merge(trade_id: trade.id)
  # end
end

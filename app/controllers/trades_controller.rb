class TradesController < ApplicationController
  def index
    @item = Item.find(params[:item_id])
  end

  def new
  end

  def create
    @trade = Trade.new(trade_params)
    if @trade.save
      redirect_to root_path
    else
      render action: :index
    end
  end

  private

  def trade_params
    params.require(:address).permit(:trade_id, :postal_code, :prefecture_id, :city, :address, :building, :phone_number)
    # .merge(user_id: current_user.id, item_id: params[:item_id])
  end
end

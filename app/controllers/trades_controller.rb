class TradesController < ApplicationController
  def index
    @item = Item.find(params[:item_id])
    
  end

  def create
    @item = Item.find(params[:item_id])
    @item_trade = ItemTrade.new(trade_params) 
    if @item_trade.valid?
      pay_item
      @item_trade.save
      return redirect_to root_path
    else
      render :index
    end
  end

  private

  def trade_params
    params.permit(:postal_code, :prefecture_id, :city, :address, :building, :phone_number, :user_id, :item_id, :token).merge(user_id: current_user.id, token: params[:token])
  end

  def pay_item
    Payjp.api_key = "テスト秘密鍵"
    Payjp::Charge.create(
      amount: @item.price,
      card: @item_trade.token,
      currency: 'jpy'
    )
  end
end

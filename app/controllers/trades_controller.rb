class TradesController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :move_to_root, only: [:index]
  before_action :set_trade, only: [:index, :create]

  def index
    @item_trade = ItemTrade.new
  end

  def create
    @item_trade = ItemTrade.new(trade_params)
    if @item_trade.valid?
      pay_item
      @item_trade.save
      redirect_to root_path
    else
      render :index
    end
  end

  private

  def trade_params
    params.require(:item_trade)
          .permit(:postal_code, :prefecture_id, :city, :address, :building, :phone_number, :user_id, :item_id, :token)
          .merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  end

  def move_to_root
    @item = Item.find(params[:item_id])
    redirect_to root_path if current_user.id == @item.user_id || @item.trade.present?
  end

  def set_trade
    @item = Item.find(params[:item_id])
  end

  def pay_item
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: @item.price,
      card: @item_trade.token,
      currency: 'jpy'
    )
  end
end

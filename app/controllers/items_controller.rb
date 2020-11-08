class ItemsController < ApplicationController
before_action :authenticate_user! , except:[:index, :show]
before_action :move_to_index, only: [:edit]
before_action :set_item, only: [:edit, :update, :show, :destroy]

  def index
    @items = Item.order("created_at DESC")
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path
    else
      render :edit
    end
  end

  def destroy
    if user_signed_in? && current_user.id == @item.user_id
      @item.destroy
      redirect_to root_path
    else
      render :show
    end
  end

  private

  def item_params
    params.require(:item).permit(:image,:name,:description,:price,:category_id,
      :condition_id,:shipping_fee_id,:ship_from_id,:delivery_date_id)
      .merge(user_id: current_user.id)
  end

  def move_to_index
    @item = Item.find(params[:id])
    @trade = Trade.find_by(item_id: @item.id)
    unless user_signed_in? && current_user.id == @item.user_id && @trade.nil?
      redirect_to root_path
    end
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
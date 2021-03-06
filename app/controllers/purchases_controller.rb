class PurchasesController < ApplicationController
  before_action :require_login, except: [:index, :show]

  def index
    render locals: { purchases: Purchase.all }
  end

  def new
    render locals: { purchase: Purchase.new }
  end

  def edit
    render locals: { purchase: current_user.purchases.find(params[:id]) }
  end

  def destroy
    current_user.purchases.find(params[:id]).destroy
    redirect_to purchases_path
  end

  def create
    purchase = Purchase.new(purchase_params)
    purchase.owner_id = current_user.id
    purchase.save ? (redirect_to purchases_path) : (render 'new')
  end

  def update
    purchase = current_user.purchases.find(params[:id])
    if purchase.update(purchase_params)
      redirect_to purchase_path(purchase)
    else
      redirect_to edit_purchase_path(purchase)
    end
  end

  def show
    render locals: { purchase: Purchase.find(params[:id]) }
  end

  private

  def purchase_params
    params.require(:purchase).permit(:name, :description, :end_date)
  end
end

class PacksController < ApplicationController
  before_action :set_pack, only: [:new_payment]

  def index
    @purchase_packs = {
      single: PurchasePack.single,
      combo: PurchasePack.combo
    }
  end

  def new_payment
  end

  private def set_pack
    unless @pack = PurchasePack.find_by_id(params[:id])
      redirect_to packs_path, notice: 'Pack not found, please select a valid pack!'
    end
  end
end

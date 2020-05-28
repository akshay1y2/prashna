class PacksController < ApplicationController
  def index
    @purchase_packs = {
      single: PurchasePack.single,
      combo: PurchasePack.combo
    }
  end
end

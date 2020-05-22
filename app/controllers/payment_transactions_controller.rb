class PaymentTransactionsController < ApplicationController
  before_action :set_pack, only: [:new, :create]

  def index
    @payment_transactions = current_user.payment_transactions.order(created_at: 'desc').page(params[:page])
  end

  def create
    current_user.build_credits_and_payment_transaction(@pack)
    if current_user.save
      redirect_to packs_path, notice: 'Transaction Done'
    else
      redirect_to packs_path, notice: 'Transaction Unsuccessful'
    end
  end

  private def set_pack
    #FIXME_AB: only enabled
    unless @pack = PurchasePack.find_by_id(params[:id])
      redirect_to packs_path, notice: 'Pack not found, please select a valid pack!'
    end
  end
end

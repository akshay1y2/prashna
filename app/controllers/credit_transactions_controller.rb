class CreditTransactionsController < ApplicationController
  def index
    @credit_transactions = current_user.credit_transactions.order(created_at: 'desc').page(params[:page])
    @credits = current_user.credits
  end
end

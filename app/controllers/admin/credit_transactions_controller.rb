module Admin
  class CreditTransactionsController < BaseController
    before_action :set_user

    def index
      @credit_transactions = @user.credit_transactions.order(created_at: 'desc').page(params[:page])
    end

    private def set_user
      unless @user = User.find_by_id(params[:id])
        redirect_to admin_users_path, notice: 'User not found!'
      end
    end
  end
end
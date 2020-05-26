class PaymentTransactionsController < ApplicationController
  before_action :set_pack, only: [:new, :create]
  rescue_from Stripe::CardError, with: :catch_exception

  def index
    @payment_transactions = current_user.payment_transactions.order(created_at: 'desc').page(params[:page])
  end

  def create
    current_user.build_credits_and_payment_transaction(@pack)
    create_charge(find_customer)
    if current_user.save
      redirect_to packs_path, notice: 'Transaction Done'
    else
      redirect_to packs_path, notice: 'Transaction Unsuccessful'
    end
  end

  private

    def set_pack
      unless @pack = PurchasePack.enabled.find_by_id(params[:id])
        redirect_to packs_path, notice: 'Pack not found, please select a valid pack!'
      end
    end

    def charges_params
      params.permit(:stripeEmail, :stripeToken, :order_id)
    end

    def catch_exception(exception)
      flash[:error] = exception.message
    end

    def find_customer
      if current_user.stripe_token
        Stripe::Customer.retrieve(params[:stripeToken])
      else
        customer = Stripe::Customer.create(
          email: stripe_email,
          source: params[:stripeToken]
        )
        current_user.update(stripe_token: customer.id)
        customer
      end
    end
  
    def create_charge(customer)
      Stripe::Charge.create(
        customer: customer.id,
        amount: @pack.current_price,
        description: customer.email,
        currency: DEFAULT_CURRENCY
      )
    end
end

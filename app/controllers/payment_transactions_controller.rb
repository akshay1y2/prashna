class PaymentTransactionsController < ApplicationController
  before_action :set_pack, only: [:new, :create]
  rescue_from Stripe::StripeError, with: :catch_exception

  def index
    @payment_transactions = current_user.payment_transactions.order(created_at: 'desc').page(params[:page])
  end

  def create
    @payment_transaction = current_user.build_payment_transaction(@pack)
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

    def catch_exception(exception)
      @payment_transaction.error_message = 'INVALID_STRIPE_OPERATION'
      @payment_transaction.status = :failed
    end

    def create_charge(customer)
      charge = Stripe::Charge.create({
        amount: (@pack.current_price * 100).to_int,
        source: params[:stripeToken],
        currency: 'inr',
        description: customer.email
      })
      Stripe::Charge.update(charge.id, { customer: customer.id })

      if charge&.id.present?
        @payment_transaction.charge_id = charge.id
        @payment_transaction.status = :paid
        current_user.build_credit_transaction(@pack)
      else
        @payment_transaction.status = :failed
      end
      charge
    end

    def find_customer
      if current_user.stripe_token
        Stripe::Customer.retrieve(current_user.stripe_token) 
      else
        customer = Stripe::Customer.create(
          email: current_user.email,
          name: current_user.name,
          address: {city: '', country: '', line1: '', line2: "", postal_code: '', state: ''}  
        )
        current_user.stripe_token = customer.id
      customer
      end
    end
end

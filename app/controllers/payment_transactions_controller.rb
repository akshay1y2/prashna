class PaymentTransactionsController < ApplicationController
  before_action :set_pack, only: [:new, :create]
  before_action :check_stripe_token_in_param, only: [:create]

  def index
    @payment_transactions = current_user.payment_transactions.includes([:purchase_pack]).order(created_at: 'desc').page(params[:page])
  end

  def create
    logger.tagged("payment_transaction: create") do
      logger.info("ensure if customer for user[#{current_user}] exists")
      current_user.ensure_stripe_customer_exists
      logger.info('creating a pending payment')
      @payment_transaction = current_user.create_pending_payment_transaction(@pack)
      status, message = create_charge(Stripe::Customer.retrieve(current_user.stripe_token))
      logger.info("received status: #{status}, message: #{message} after creating charge.")
      if status
        logger.info("marking transaction as paid!")
        @payment_transaction.mark_paid!(@charge, params[:stripeToken])
        redirect_to packs_path, notice: t('.transaction_success')
      else
        logger.info("marking transaction as failed!")
        @payment_transaction.mark_failed!(message, params[:stripeToken])
        redirect_to packs_path, notice: t('.transaction_failed', {error: message})
      end
    end
  end

  private

    def set_pack
      unless @pack = PurchasePack.enabled.find_by_id(params[:id])
        redirect_to packs_path, notice: t('.pack_not_found')
      end
    end

    def check_stripe_token_in_param
      if params[:stripeToken].blank?
        redirect_to packs_path, notice: t('.payment_not_processed')
      end
    end

    def create_charge(customer)
      logger.tagged("payment_transaction: create: charge") do
        begin
          charge_data = {
            amount: (@pack.current_price * 100).to_int,
            source: params[:stripeToken],
            currency: PurchasePack::CURRENCY,
            description: "#{Rails.env} - PurchasePack-#{@pack.id}",
            statement_descriptor_suffix: "Prashna Pack-#{@pack.name}".first(22),
          }
          logger.info("Creating charge with data: #{charge_data}")
          @charge = Stripe::Charge.create(charge_data)

          logger.info("Updating charge: #{@charge.id} with customer: #{customer.id}")
          Stripe::Charge.update(@charge.id, { customer: customer.id })
          return true
        rescue Stripe::StripeError => error
          logger.info("Exception Occured: #{error}")
          return [false, error.message]
        end
      end
    end
end

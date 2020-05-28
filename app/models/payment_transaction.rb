class PaymentTransaction < ApplicationRecord
  include NotDeleteable
  paginates_per 10

  enum status: { pending: 0, failed: 1, paid: 2, refunded: 3 }

  validates :amount, :credits, numericality: { greater_than_or_equal_to: 0 }, presence: true

  belongs_to :purchase_pack
  belongs_to :user

  def mark_paid!(charge, token)
    logger.tagged('marking: paid') do
      self.stripe_token = token
      self.charge_id = charge.id
      self.paid_at = Time.current
      self.charge_response = charge
      logger.info("marking transaction as paid! with stripe_token: #{token}, charge: #{charge}")
      paid!
      successful_transaction_tasks
      logger.info('callbacks ran after marking as paid!')
    end
  end

  def mark_failed!(message, token)
    logger.tagged('marking: failed') do
      self.stripe_token = token
      self.error_message = message
      logger.info("marking as failed! with stripe_token: #{token}, message: #{message}")
      failed!
    end
  end

  def refund!
    logger.tagged('payment_transaction: marking: refunded') do
      unless paid?
        logger.info("transaction with id: #{id} is not paid, exiting...")
        return 'This Transaction has not been paid!'
      end

      begin
        logger.info("refunding with charge: #{charge_id}")
        refund = Stripe::Refund.create(charge: charge_id)
        self.refunded_at = Time.current
        refunded!
        refund_transaction_tasks
        logger.info("callbacks ran after marking as refunded")
      rescue Stripe::StripeError => error
        logger.info("Exception Occurred: #{error}")
        error.message
      end
    end
  end

  private def successful_transaction_tasks
    user.create_credit_transaction(purchase_pack)
    PaymentTransactionMailer.with(id: id).paid.deliver_later
  end

  private def refund_transaction_tasks
    user.create_refund_credit_transaction(purchase_pack)
    PaymentTransactionMailer.with(id: id).refunded.deliver_later
  end
end

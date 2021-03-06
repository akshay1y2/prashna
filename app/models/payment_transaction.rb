# == Schema Information
#
# Table name: payment_transactions
#
#  id               :bigint           not null, primary key
#  credits          :integer          default(0), not null
#  purchase_pack_id :bigint           not null
#  user_id          :bigint           not null
#  amount           :decimal(, )      default(0.0), not null
#  status           :integer          default("pending"), not null
#  stripe_token     :string
#  charge_id        :string
#  error_message    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  paid_at          :datetime
#  refunded_at      :datetime
#  charge_response  :jsonb            not null
#
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
    PaymentTransactionMailer.delay.paid(id)
  end

  private def refund_transaction_tasks
    user.create_refund_credit_transaction(purchase_pack)
    PaymentTransactionMailer.delay.refunded(id)
  end
end

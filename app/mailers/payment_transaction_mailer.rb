class PaymentTransactionMailer < ApplicationMailer
  def paid(id)
    @pt = PaymentTransaction.find(id)
    @user = @pt.user
    if @pt && @pt.paid?
      mail to: @user.email, subject: 'Payment Successful.'
    end
  end

  def refunded(id)
    @pt = PaymentTransaction.find(id)
    @user = @pt.user
    if @pt && @pt.refunded?
      mail to: @user.email, subject: 'Payment Refunded.'
    end
  end
end

class PaymentTransactionMailer < ApplicationMailer
  def paid
    @pt = PaymentTransaction.find(params[:id])
    @user = @pt.user
    if @pt && @pt.paid?
      mail to: @user.email, subject: 'Payment Successful.'
    end
  end

  def refunded
    @pt = PaymentTransaction.find(params[:id])
    @user = @pt.user
    if @pt && @pt.refunded?
      mail to: @user.email, subject: 'Payment Refunded.'
    end
  end
end

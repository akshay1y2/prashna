class ApplicationMailer < ActionMailer::Base
  #FIXME_AB: we have hardcoded this email. set it per env. Lets figaro gem https://github.com/laserlemon/figaro
  default from: 'admin@prashna.com'
  layout 'mailer'
end

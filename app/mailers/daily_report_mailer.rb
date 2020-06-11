class DailyReportMailer < ApplicationMailer
  def send_report(from, to)
    @questions = Question.published.where published_at: from..to
    mail to: 'management@prashna.com', subject: 'Daily Questions Report.'
  end
end

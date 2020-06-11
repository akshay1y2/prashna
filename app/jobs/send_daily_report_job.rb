class SendDailyReportJob < ApplicationJob
  queue_as :daily_reports

  def perform(**duration)
    DailyReportMailer.send_report(duration[:from] || 1.day.ago, duration[:to] || Time.current)
  end
end

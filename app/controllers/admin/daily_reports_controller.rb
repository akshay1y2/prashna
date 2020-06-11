module Admin
  class DailyReportsController < BaseController
    def send_report
      Delayed::Job.enqueue SendDailyReportJob.perform_later(from: 2.day.ago, to: Time.current)
      redirect_to admin_root_path, notice: 'The mail is Queued successfully.'
    end
  end
end

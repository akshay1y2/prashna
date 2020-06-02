namespace :api_requests do
  desc 'Delete 24 hrs old entries from api requests.'
  task delete_old_records: :environment do
    ApiRequest.before_time(24.hour.ago).find_each { |ar| ar.destroy }
  end
end

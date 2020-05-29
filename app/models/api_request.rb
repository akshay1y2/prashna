class ApiRequest < ApplicationRecord
  scope :by_ip, ->(ip = '') { where client_ip: ip }
  scope :after_time, ->(time = 1.hour.ago) { where 'created_at > ?', time }
end

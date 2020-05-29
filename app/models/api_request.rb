# == Schema Information
#
# Table name: api_requests
#
#  id         :bigint           not null, primary key
#  client_ip  :string           default(""), not null
#  path       :string           default("/api/"), not null
#  created_at :datetime         not null
#
class ApiRequest < ApplicationRecord
  scope :by_ip, ->(ip = '') { where client_ip: ip }
  scope :after_time, ->(time = 1.hour.ago) { where 'created_at > ?', time }

  #FIXME_AB: make a rake task which will delete all requests from this table which are added 24 hours ago
end

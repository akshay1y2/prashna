# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  name                    :string
#  email                   :string
#  password_digest         :string
#  admin                   :boolean          default(FALSE), not null
#  credits                 :integer          default(0), not null
#  active                  :boolean          default(FALSE), not null
#  confirm_token           :string
#  reset_token             :string
#  reset_sent_at           :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  new_notifications_count :integer          default(0), not null
#  stripe_token            :string
#  auth_token              :string
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

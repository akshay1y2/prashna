namespace :user do
  desc 'update credit balance of all users.'
  task update_credit_balance: :environment do
    User.find_in_batches do |users|
      users.each do |user|
        user.credits = user.credit_transactions.sum('credits')
        unless user.save
          puts "\nErrors while updating user with email: #{user.email}"
          user.errors.each{ |e, m| puts "- #{e}: #{m}" }
        end
      end
    end
  end

  desc 'add auth_token to the active users without auth_token'
  task add_auth_tokens: :environment do
    User.active.without_auth_token.find_each do |user|
      Rails.logger.tagged 'user:add_auth_tokens' do
        Rails.logger.info "[+] Adding auth_token to user_id: #{user.id}"
        user.set_auth_token
        if user.save
          Rails.logger.info "[+] Added auth_token to user_id: #{user.id}"
        else
          Rails.logger.info "[-] Cannot add auth_token to user_id: #{user.id}, errors: #{user.errors}"
          puts "\nErrors while updating user with email: #{user.email}"
          user.errors.each{ |e, m| puts "- #{e}: #{m}" }
        end
      end
    end
  end
end

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
end
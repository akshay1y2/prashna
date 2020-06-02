namespace :admin do
  desc 'Make a new admin'
  task new: :environment do
    def input_for(str)
      print(str)
      STDIN.gets.chomp
    end

    user = User.new(
      name: input_for('Name: '),
      email: input_for('Email: '),
      password: STDIN.getpass("Password:"),
      password_confirmation: STDIN.getpass("Confirm Password:"),
      auth_token: SecureRandom.urlsafe_base64,
      admin: true,
      active: true
    )
    if user.save
      puts "\nNew admin has been created with email: #{user.email}."
    else
      puts "\nErrors while creating admin with email: #{user.email}"
      user.errors.each{ |e, m| puts "- #{e}: #{m}" }
    end
  end
end

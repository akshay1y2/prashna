FactoryBot.define do
  factory :user do
    name {'user_name'}
    email {'user@mail.com'}
    password_digest {'$2a$12$sEUMDYctapJ63paqtrhPWOWstyRPGbvzpeNkdGs.ddiT1tgqHAlBW'}
    credits {1}
    active {true}
    auth_token { set_auth_token }

    trait 'first_user' do
      name {'user-one'}
      email {'u_one@mail.com'}
    end

    trait 'second_user' do
      name {'user-two'}
      email {'u_two@mail.com'}
    end
  end
end

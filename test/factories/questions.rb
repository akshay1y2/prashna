FactoryBot.define do
  factory :question do
    title {'title'}
    topics {[Topic.create(name: 'rails')]}
    content {'text'}
    comments_count {0}
    answers_count {0}
    net_upvotes {0}
    marked_abuse {false}
    user
  end
end

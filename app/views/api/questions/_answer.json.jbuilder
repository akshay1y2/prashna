json.user answer.user.name
json.extract! answer, :content, :comments_count, :net_upvotes
json.comments answer.comments, partial: 'api/questions/comment', as: :comment

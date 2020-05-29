json.user question.user.name
json.extract! question, :title, :content, :published_at, :comments_count, :answers_count, :net_upvotes
json.url question_url(question)
json.topics question.topic_names
json.comments question.comments.includes([:user]), partial: 'api/questions/comment', as: :comment
json.answers question.answers.includes([:user, :comments]), partial: 'api/questions/answer', as: :answer

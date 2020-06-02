module Api
  class QuestionsController < BaseController
    skip_before_action :rate_limit_api_calls, only: [:feed]
    skip_around_action :save_api_request, only: [:feed]
    skip_before_action :authorize, only: [:index]

    def index
      @questions = Question.published.includes([:user]).order(published_at: :desc).limit(ENV['array_limit_for_json'])
    end

    def feed
      @questions = Question
        .distinct
        .joins(:questions_topics)
        .where(questions_topics: {topic_id: @user.topics})
        .published
        .includes([:user])
        .order(published_at: :desc)
        .limit(ENV['array_limit_for_json'])
      render 'api/questions/index'
    end
  end
end

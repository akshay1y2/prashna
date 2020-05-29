module Api
  class QuestionsController < BaseController
    skip_before_action :rate_limit_api_calls, only: [:feed]
    skip_before_action :authorize, only: [:index]

    def index
      respond_to do |format|
        format.json { @questions = Question.all_published.includes([:user]).order(published_at: :desc) }
        format.html { render plain: 'Invalid URL' }
      end
    end

    def feed
      @questions = Question
        .distinct
        .joins(:questions_topics)
        .where(questions_topics: {topic_id: @user.topics})
        .all_published
        .includes([:user])
        .order(published_at: :desc)
      render 'api/questions/index'
    end
  end
end
